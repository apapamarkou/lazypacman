#!/usr/bin/env bash
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
