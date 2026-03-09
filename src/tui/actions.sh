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
# TUI actions

require core/prompt
require cache/cache

# Handle package selection (install/remove)
handle_package_action() {
    local line="$1"
    local pkg
    pkg=$(echo "$line" | awk '{print $3}')
    
    [[ -z "$pkg" ]] && return
    
    if is_installed "$pkg"; then
        remove_package "$pkg"
    else
        if ask_yn "Install $pkg? (Y/N): "; then
            local source
            source=$(get_package_source "$pkg")
            
            if [[ "$source" == "repo" ]]; then
                sudo pacman -S --needed --noconfirm "$pkg"
            else
                yay -S --needed "$pkg"
            fi
        else
            echo "Cancelled."
        fi
    fi
    
    read -rp "Press Enter to continue..."
}
