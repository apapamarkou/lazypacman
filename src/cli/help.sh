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
# Help text

show_help() {
    cat << 'EOF'
pkg - Fast TUI + CLI package manager wrapper for Arch Linux

USAGE:
    pkg                          Launch interactive TUI
    pkg <command> [args]         Run CLI command

COMMANDS:
    install, i <package>...      Install package(s)
    remove, r <package>...       Remove package(s)
    info <package>               Show package information
    search, s <term>             Search packages
    search-names-only, sno <term> Search package names only
    update, u                    Update system
    clean-orphans, co            Remove orphan packages
    help, h                      Show this help

TUI KEY BINDINGS:
    Enter       Install/remove package
    Ctrl+U      System update
    Ctrl+O      Clean orphan packages
    Ctrl+B      Preview PKGBUILD (AUR)
    Ctrl+Q/ESC  Exit

EXAMPLES:
    pkg install neovim
    pkg install vim git curl
    pkg info firefox
    pkg search firefox
    pkg update
EOF
}
