#!/usr/bin/env bash
# Package cache management

# Check if cache needs rebuild
cache_needs_rebuild() {
    [[ ! -f "$CACHE_FILE" ]] && return 0
    
    local cache_age=$(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)))
    [[ $cache_age -gt $CACHE_MAX_AGE ]] && return 0
    
    return 1
}

# Build package cache
build_cache() {
    mkdir -p "$CACHE_DIR"
    
    {
        pacman -Slq | while read -r pkg; do
            jq -nc --arg name "$pkg" --arg source "repo" '{name: $name, source: $source}'
        done
        
        yay -Slq 2>/dev/null | while read -r pkg; do
            pacman -Si "$pkg" &>/dev/null && continue
            jq -nc --arg name "$pkg" --arg source "aur" '{name: $name, source: $source}'
        done
    } > "$CACHE_FILE"
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
    
    if [[ "$names_only" == "true" ]]; then
        jq -r 'select(.name | contains("'"$term"'")) | "\(.name) \(.source)"' "$CACHE_FILE"
    else
        jq -r 'select(.name | contains("'"$term"'")) | "\(.name) \(.source)"' "$CACHE_FILE"
    fi
}

# Get all packages from cache
get_all_packages() {
    ensure_cache
    jq -r '"\(.name) \(.source)"' "$CACHE_FILE"
}
