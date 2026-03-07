#!/usr/bin/env bash
# Dependency checking

REQUIRED_DEPS=(pacman yay fzf jq curl)

# Check if all dependencies are installed
check_dependencies() {
    local missing=()
    
    for dep in "${REQUIRED_DEPS[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${COLOR_RED}Error: Missing dependencies: ${missing[*]}${COLOR_RESET}" >&2
        return 1
    fi
    
    return 0
}
