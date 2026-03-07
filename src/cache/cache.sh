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
    
    # Repo packages - fast streaming with awk
    pacman -Slq | awk '{print "{\"name\":\"" $0 "\",\"source\":\"repo\"}"}'  > "$tmpfile"
    
    # AUR packages - optional (slow)
    if [[ "$INCLUDE_AUR" == "1" ]] && command -v yay &>/dev/null; then
        echo "Including AUR packages (this may take a while)..." >&2
        
        # Build repo list once, then filter AUR against it
        local repo_list="${CACHE_DIR}/repo.tmp"
        pacman -Slq | sort > "$repo_list"
        
        yay -Slq 2>/dev/null | sort | comm -13 "$repo_list" - | \
            awk '{print "{\"name\":\"" $0 "\",\"source\":\"aur\"}"}'  >> "$tmpfile"
        
        rm -f "$repo_list"
    fi
    
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
