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
# TUI preview generation - lazy on-demand loading

# Colorize package names in dependency lines
colorize_deps() {
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

# Generate preview for package (called on-demand by fzf)
generate_preview() {
    local line="$1"
    local pkg
    pkg=$(echo "$line" | awk '{print $3}')
    
    [[ -z "$pkg" ]] && { echo "No package selected"; return; }
    
    # Fetch package info on-demand
    local info
    info=$(get_package_info "$pkg" 2>/dev/null)
    
    if [[ -n "$info" ]]; then
        # Parse and colorize package info
        echo -e "${COLOR_CYAN}╭────────────────────────────────────────${COLOR_RESET}"
        mapfile -t lines <<< "$info"
        for line in "${lines[@]}"; do
            # Check if line starts with space (continuation line)
            if [[ "$line" =~ ^[[:space:]] ]]; then
                # Continuation line - colorize installed packages
                local colored_line
                colored_line=$(colorize_deps "$line")
                echo -e "${COLOR_CYAN}│${COLOR_RESET} ${COLOR_GREY}${colored_line}${COLOR_RESET}"
            elif [[ "$line" =~ ^([^:]+):(.*)$ ]]; then
                # Field line - field name in blue, value in grey
                local field="${BASH_REMATCH[1]}"
                local value="${BASH_REMATCH[2]}"
                value="${value# }"  # Trim leading space
                
                # Colorize installed packages in Depends On and Optional Deps fields
                if [[ "$field" =~ "Depends On"|"Optional Deps" ]]; then
                    local colored_value
                    colored_value=$(colorize_deps "$value")
                    if [[ -z "$value" ]]; then
                        echo -e "${COLOR_CYAN}│${COLOR_RESET} ${COLOR_BLUE}${field}:${COLOR_RESET} ${COLOR_GREY}None${COLOR_RESET}"
                    else
                        echo -e "${COLOR_CYAN}│${COLOR_RESET} ${COLOR_BLUE}${field}:${COLOR_RESET} ${COLOR_GREY}${colored_value}${COLOR_RESET}"
                    fi
                else
                    if [[ -z "$value" ]]; then
                        echo -e "${COLOR_CYAN}│${COLOR_RESET} ${COLOR_BLUE}${field}:${COLOR_RESET} ${COLOR_GREY}None${COLOR_RESET}"
                    else
                        echo -e "${COLOR_CYAN}│${COLOR_RESET} ${COLOR_BLUE}${field}:${COLOR_RESET} ${COLOR_GREY}${value}${COLOR_RESET}"
                    fi
                fi
            fi
        done
        echo -e "${COLOR_CYAN}╰────────────────────────────────────────${COLOR_RESET}"
        echo
        
        # Show dependency tree only if package is installed
        if pacman -Q "$pkg" &>/dev/null; then
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
        else
            echo -e "${COLOR_CYAN}▶ Dependency Tree${COLOR_RESET}"
            # Show dependencies from package info for non-installed packages
            local deps
            if pacman -Si "$pkg" &>/dev/null; then
                deps=$(pacman -Si "$pkg" | grep -E '^Depends On' | sed 's/Depends On *: //')
            elif command -v yay &>/dev/null; then
                deps=$(yay -Si "$pkg" 2>/dev/null | grep -E '^Depends On' | sed 's/Depends On *: //')
            fi
            
            if [[ -n "$deps" && "$deps" != "None" ]]; then
                # Display root package
                echo -e "  ${COLOR_BOLD}${COLOR_GREY}$pkg${COLOR_RESET}"
                # Parse and display each dependency as tree with install status
                IFS=' ' read -ra dep_array <<< "$deps"
                local total=${#dep_array[@]}
                local i=0
                for dep in "${dep_array[@]}"; do
                    [[ -z "$dep" ]] && continue
                    i=$((i + 1))
                    # Remove version constraints
                    dep_name="${dep%%[<>=]*}"
                    
                    # Tree characters
                    if [[ $i -eq $total ]]; then
                        local prefix="  └─"
                    else
                        local prefix="  ├─"
                    fi
                    
                    if pacman -Q "$dep_name" &>/dev/null; then
                        echo -e "${prefix} ${COLOR_GREEN}$dep_name${COLOR_RESET}"
                    else
                        echo -e "${prefix} ${COLOR_DIM}$dep_name${COLOR_RESET}"
                    fi
                done
            else
                echo -e "  ${COLOR_DIM}None${COLOR_RESET}"
            fi
        fi
    else
        echo -e "${COLOR_CYAN}╭────────────────────────────────────────${COLOR_RESET}"
        echo -e "${COLOR_CYAN}│${COLOR_RESET} ${COLOR_CYAN}Package:${COLOR_RESET} ${COLOR_GREY}$pkg${COLOR_RESET}"
        echo -e "${COLOR_CYAN}│${COLOR_RESET} ${COLOR_CYAN}Status:${COLOR_RESET} ${COLOR_GREY}Information not available${COLOR_RESET}"
        echo -e "${COLOR_CYAN}╰────────────────────────────────────────${COLOR_RESET}"
    fi
}

# Preview PKGBUILD for AUR package (Ctrl+B)
preview_pkgbuild() {
    local pkg="$1"
    [[ -z "$pkg" ]] && return
    
    local tmpdir
    tmpdir=$(mktemp -d)
    
    cd "$tmpdir" || return
    
    echo "Fetching PKGBUILD for $pkg..."
    if yay -G "$pkg" &>/dev/null && [[ -f "$pkg/PKGBUILD" ]]; then
        most "$pkg/PKGBUILD"
    else
        echo "PKGBUILD not available for $pkg"
        read -rp "Press Enter to continue..."
    fi
    
    cd - &>/dev/null || exit
    rm -rf "$tmpdir"
}
