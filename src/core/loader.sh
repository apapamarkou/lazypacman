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
# Module loader - prevents duplicate imports

declare -A _LOADED_MODULES

# Load a module by name
require() {
    local module="$1"
    [[ -n "${_LOADED_MODULES[$module]:-}" ]] && return 0
    
    local module_path="${MODULE_DIR}/${module}.sh"
    if [[ ! -f "$module_path" ]]; then
        echo "Error: Module not found: $module" >&2
        exit 1
    fi
    
    source "$module_path"
    _LOADED_MODULES[$module]=1
}
