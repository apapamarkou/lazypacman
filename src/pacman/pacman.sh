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
# Pacman operations

# Install package
install_package() {
    local pkg="$1"
    
    # Check if already installed
    if is_installed "$pkg"; then
        echo -e "${COLOR_GREEN}Package '$pkg' is already installed.${COLOR_RESET}"
        return 0
    fi
    
    local source
    source=$(get_package_source "$pkg")
    
    if [[ "$source" == "repo" ]]; then
        sudo pacman -S --needed "$pkg"
    else
        yay -S --needed "$pkg"
    fi
}

# Remove package with dependency warning
remove_package() {
    local pkg="$1"
    
    if ! is_installed "$pkg"; then
        echo -e "${COLOR_RED}Package not installed: $pkg${COLOR_RESET}"
        return 1
    fi
    
    local rdeps
    rdeps=$(pactree -r "$pkg" 2>/dev/null | tail -n +2)
    
    if [[ -n "$rdeps" ]]; then
        echo "The following packages depend on this package:"
        echo
        echo "$rdeps"
        echo
        echo "Removing it may break them."
        echo
    fi
    
    if ask_yn "Remove $pkg? (Y/N): "; then
        sudo pacman -R "$pkg"
    else
        echo "Cancelled."
    fi
}

# Get package info
get_package_info() {
    local pkg="$1"
    local source
    source=$(get_package_source "$pkg")
    
    if [[ "$source" == "repo" ]]; then
        pacman -Si "$pkg" 2>/dev/null
    else
        yay -Si "$pkg" 2>/dev/null
    fi
}
