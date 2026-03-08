#!/usr/bin/env bash
# CLI command implementations

# CLI install command
cli_install() {
    [[ $# -eq 0 ]] && { echo "Usage: pkg install <package> [package2] [package3] ..."; exit 1; }
    for pkg in "$@"; do
        install_package "$pkg"
    done
}

# CLI remove command
cli_remove() {
    [[ $# -eq 0 ]] && { echo "Usage: pkg remove <package> [package2] [package3] ..."; exit 1; }
    for pkg in "$@"; do
        remove_package "$pkg"
    done
}

# CLI info command
cli_info() {
    local pkg="$1"
    [[ -z "$pkg" ]] && { echo "Usage: pkg info <package>"; exit 1; }
    
    local info
    info=$(get_package_info "$pkg" 2>/dev/null)
    
    if [[ -n "$info" ]]; then
        echo "$info"
        echo
        if is_installed "$pkg"; then
            echo -e "${COLOR_CYAN}Dependency Tree:${COLOR_RESET}"
            pactree "$pkg" 2>/dev/null || echo "  (not available)"
        fi
    else
        echo -e "${COLOR_RED}Package '$pkg' not found${COLOR_RESET}"
        exit 1
    fi
}

# CLI search command
cli_search() {
    local term="$1"
    local names_only="${2:-false}"
    [[ -z "$term" ]] && { echo "Usage: pkg search <term>"; exit 1; }
    
    # Build installed packages map for fast lookup
    declare -A installed_map
    while read -r pkg; do
        installed_map[$pkg]=1
    done < <(pacman -Qq)
    
    search_cache "$term" "$names_only" | while read -r pkg source; do
        local is_installed=0
        [[ -n "${installed_map[$pkg]:-}" ]] && is_installed=1
        format_package_line "$pkg" "$source" "$is_installed"
    done
}

# CLI update command
cli_update() {
    perform_update
}

# CLI clean orphans command
cli_clean_orphans() {
    clean_orphans
}
