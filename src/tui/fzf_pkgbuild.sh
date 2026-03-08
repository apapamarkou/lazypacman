#!/usr/bin/env bash

# shellcheck disable=SC1091  # Module loader path resolved at runtime
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
# PKGBUILD preview helper for fzf

MODULE_DIR="${MODULE_DIR:-$(dirname "$0")}"
source "$MODULE_DIR/core/loader.sh"

require tui/preview

pkg=$(echo "$1" | awk '{print $3}')
preview_pkgbuild "$pkg"
