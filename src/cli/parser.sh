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
# CLI argument parser

# Parse and execute CLI commands
parse_cli() {
    local cmd="$1"
    shift
    
    case "$cmd" in
        install|i)
            cli_install "$@"
            ;;
        remove|r)
            cli_remove "$@"
            ;;
        search|s)
            cli_search "$@" false
            ;;
        search-names-only|sno)
            cli_search "$@" true
            ;;
        info)
            cli_info "$@"
            ;;
        update|u)
            cli_update
            ;;
        clean-orphans|co)
            cli_clean_orphans
            ;;
        help|h|--help|-h)
            show_help
            ;;
        *)
            echo "Unknown command: $cmd"
            echo "Run 'pkg help' for usage information"
            exit 1
            ;;
    esac
}
