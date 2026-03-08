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
# Orphan package cleaner

# Clean orphan packages
clean_orphans() {
    local orphans
    orphans=$(pacman -Qtdq 2>/dev/null)
    
    if [[ -z "$orphans" ]]; then
        echo "No orphan packages found."
        return 0
    fi
    
    echo "Orphan packages:"
    echo "$orphans"
    echo
    if ask_yn "Remove these packages? (Y/N): "; then
        sudo pacman -Rns "$orphans"
    else
        echo "Cancelled."
    fi
}
