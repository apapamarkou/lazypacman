#!/usr/bin/env bash
# CLI command implementations

# CLI install command
cli_install() {
    local pkg="$1"
    [[ -z "$pkg" ]] && { echo "Usage: pkg install <package>"; exit 1; }
    install_package "$pkg"
}

# CLI remove command
cli_remove() {
    local pkg="$1"
    [[ -z "$pkg" ]] && { echo "Usage: pkg remove <package>"; exit 1; }
    remove_package "$pkg"
}

# CLI search command
cli_search() {
    local term="$1"
    local names_only="${2:-false}"
    [[ -z "$term" ]] && { echo "Usage: pkg search <term>"; exit 1; }
    
    search_cache "$term" "$names_only" | while read -r pkg source; do
        format_package_line "$pkg" "$source"
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
