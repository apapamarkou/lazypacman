#!/usr/bin/env bash

#  _                    ____                                  
# | |    __ _ _____   _|  _ \ __ _  ___ _ __ ___   __ _ _ __  
# | |   / _` |_  / | | | |_) / _` |/ __| '_ ` _ \ / _` | '_ \ 
# | |__| (_| |/ /| |_| |  __/ (_| | (__| | | | | | (_| | | | |
# |_____\__,_/___|\__, |_|   \__,_|\___|_| |_| |_|\__,_|_| |_|
#                 |___/                                
# 
# Fast TUI + CLI package manager wrapper for Arch Linux
# Author: Andrianos Papamarkou
# email: papamarkoua@gmail.com
#
# CLI command implementations

require tui/preview

# Colorize package names in dependency lines (for CLI)
colorize_deps_cli() {
    local text="$1"
    local result="$text"
    
    # Find and colorize each package name
    local words
    read -ra words <<< "$text"
    for word in "${words[@]}"; do
        # Extract package name (remove version constraints and colons)
        local pkg="${word%%[:<>=]*}"
        if [[ -n "$pkg" ]] && pacman -Q "$pkg" &>/dev/null 2>&1; then
            result="${result/"$word"/"${COLOR_GREEN}${word}${COLOR_GREY}"}"
        fi
    done
    echo -n "$result"
}

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
        (
            # Parse and colorize package info
            mapfile -t lines <<< "$info"
            for line in "${lines[@]}"; do
                # Check if line starts with space (continuation line)
                if [[ "$line" =~ ^[[:space:]] ]]; then
                    # Continuation line - colorize installed packages
                    local colored_line
                    colored_line=$(colorize_deps_cli "$line")
                    echo -e " ${COLOR_GREY}${colored_line}${COLOR_RESET}"
                elif [[ "$line" =~ ^([^:]+):(.*)$ ]]; then
                    # Field line - field name in blue, value in grey
                    local field="${BASH_REMATCH[1]}"
                    local value="${BASH_REMATCH[2]}"
                    value="${value# }"  # Trim leading space
                    
                    # Colorize installed packages in Depends On and Optional Deps fields
                    if [[ "$field" =~ "Depends On"|"Optional Deps" ]]; then
                        local colored_value
                        colored_value=$(colorize_deps_cli "$value")
                        if [[ -z "$value" ]]; then
                            echo -e " ${COLOR_BLUE}${field}:${COLOR_RESET} ${COLOR_GREY}None${COLOR_RESET}"
                        else
                            echo -e " ${COLOR_BLUE}${field}:${COLOR_RESET} ${COLOR_GREY}${colored_value}${COLOR_RESET}"
                        fi
                    else
                        if [[ -z "$value" ]]; then
                            echo -e " ${COLOR_BLUE}${field}:${COLOR_RESET} ${COLOR_GREY}None${COLOR_RESET}"
                        else
                            echo -e " ${COLOR_BLUE}${field}:${COLOR_RESET} ${COLOR_GREY}${value}${COLOR_RESET}"
                        fi
                    fi
                fi
            done
            echo
            
            # Show dependency tree if package is installed
            if is_installed "$pkg"; then
                echo -e "${COLOR_CYAN}▶ Dependency Tree${COLOR_RESET}"
                if command -v pactree &>/dev/null; then
                    pactree "$pkg" 2>/dev/null | while IFS= read -r line; do
                        if [[ "$line" == "$pkg" ]]; then
                            echo -e "  ${COLOR_BOLD}${COLOR_GREEN}$line${COLOR_RESET}"
                        else
                            echo -e "  ${COLOR_DIM}$line${COLOR_RESET}"
                        fi
                    done
                else
                    echo -e "  ${COLOR_DIM}(install 'pacman-contrib' for tree view)${COLOR_RESET}"
                fi
            fi
        ) | most
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
    
    # Count results
    local results
    results=$(search_cache "$term" "$names_only")
    local count
    count=$(echo "$results" | wc -l)
    
    if [[ $count -gt 24 ]]; then
        # Use pager for long lists
        echo "$results" | while read -r pkg source; do
            local is_installed=0
            [[ -n "${installed_map[$pkg]:-}" ]] && is_installed=1
            format_package_line "$pkg" "$source" "$is_installed"
        done | most
    else
        # Direct output for short lists
        echo "$results" | while read -r pkg source; do
            local is_installed=0
            [[ -n "${installed_map[$pkg]:-}" ]] && is_installed=1
            format_package_line "$pkg" "$source" "$is_installed"
        done
    fi
}

# CLI update command
cli_update() {
    perform_update
}

# CLI clean orphans command
cli_clean_orphans() {
    clean_orphans
}
