#!/usr/bin/env bash
# Package cache management - minimal cache for fast startup

# Check if cache needs rebuild
cache_needs_rebuild() {
    [[ ! -f "$CACHE_FILE" ]] && return 0
    
    local cache_age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)))
    [[ $cache_age -gt $CACHE_MAX_AGE ]] && return 0
    
    return 1
}

# Build minimal package cache (name + source only)
build_cache() {
    mkdir -p "$CACHE_DIR"
    local tmpfile="${CACHE_FILE}.tmp"
    
    {
        # Repo packages - fast streaming
        pacman -Slq | awk '{print "{\"name\":\"" $0 "\",\"source\":\"repo\"}"}'        
        
        # AUR packages - exclude repo duplicates
        yay -Slq 2>/dev/null | while read -r pkg; do
            pacman -Si "$pkg" &>/dev/null && continue
            printf '{"name":"%s","source":"aur"}\n' "$pkg"
        done
    } > "$tmpfile"
    
    mv "$tmpfile" "$CACHE_FILE"
}

# Ensure cache exists
ensure_cache() {
    if cache_needs_rebuild; then
        echo "Building package cache..." >&2
        build_cache
    fi
}

# Search packages in cache
search_cache() {
    local term="$1"
    local names_only="${2:-false}"
    
    ensure_cache
    jq -r 'select(.name | contains("'"$term"'")) | "\(.name) \(.source)"' "$CACHE_FILE"
}

# Stream all packages from cache (fast)
get_all_packages() {
    ensure_cache
    jq -r '"\(.name) \(.source)"' "$CACHE_FILE"
}
