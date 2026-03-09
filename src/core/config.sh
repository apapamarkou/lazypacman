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
# Configuration and constants
# shellcheck disable=SC2034  # Variables used by sourcing scripts

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/lazypacman"
CACHE_FILE="$CACHE_DIR/packages.ndjson"  # Minimal cache: name + source only
UPDATE_CHECK_FILE="$CACHE_DIR/update_check"
CACHE_MAX_AGE=$((24 * 3600))  # 24 hours
UPDATE_CHECK_INTERVAL=$((6 * 3600))  # 6 hours

# Performance: minimal cache for fast startup, lazy preview generation
# Set to 0 to disable AUR in cache (much faster)
INCLUDE_AUR="${LAZYPACMAN_INCLUDE_AUR:-1}"

# Pager detection
if [[ -z "${PAGER:-}" ]]; then
    if command -v most &>/dev/null; then
        PAGER="most"
    elif command -v less &>/dev/null; then
        PAGER="less -FR"
    else
        PAGER="more"
    fi
fi
