#!/usr/bin/env bash
# Utility functions

# Check if package is installed
is_installed() {
    pacman -Q "$1" &>/dev/null
}

# Get package source (repo or aur)
get_package_source() {
    local pkg="$1"
    if pacman -Si "$pkg" &>/dev/null; then
        echo "repo"
    else
        echo "aur"
    fi
}

# Format package line for display
format_package_line() {
    local pkg="$1"
    local source="$2"
    local installed="${3:-0}"
    local installed_mark="_"
    local source_label="AUR"
    local color="$COLOR_GREY"  # Light grey for not installed
    
    if [[ "$installed" == "1" ]]; then
        installed_mark="I"
        color="$COLOR_GREEN"
    fi
    
    if [[ "$source" == "repo" ]]; then
        source_label="Rep"
        [[ "$installed_mark" == "_" ]] && color="$COLOR_GREY"  # Light grey
    fi
    
    echo -e "${color}[${installed_mark}] [${source_label}] ${pkg}${COLOR_RESET}"
}
