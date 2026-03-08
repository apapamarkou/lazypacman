#!/usr/bin/env bash
# Pacman operations

# Install package
install_package() {
    local pkg="$1"
    
    # Check if already installed
    if is_installed "$pkg"; then
        echo -e "${COLOR_GREEN}Package '$pkg' is already installed.${COLOR_RESET}"
        return 0
    fi
    
    local source
    source=$(get_package_source "$pkg")
    
    if [[ "$source" == "repo" ]]; then
        sudo pacman -S --needed "$pkg"
    else
        yay -S --needed "$pkg"
    fi
}

# Remove package with dependency warning
remove_package() {
    local pkg="$1"
    
    if ! is_installed "$pkg"; then
        echo -e "${COLOR_RED}Package not installed: $pkg${COLOR_RESET}"
        return 1
    fi
    
    local rdeps
    rdeps=$(pactree -r "$pkg" 2>/dev/null | tail -n +2)
    
    if [[ -n "$rdeps" ]]; then
        echo "The following packages depend on this package:"
        echo
        echo "$rdeps"
        echo
        echo "Removing it may break them."
        echo
    fi
    
    if ask_yn "Remove $pkg? (Y/N): "; then
        sudo pacman -R "$pkg"
    else
        echo "Cancelled."
    fi
}

# Get package info
get_package_info() {
    local pkg="$1"
    local source
    source=$(get_package_source "$pkg")
    
    if [[ "$source" == "repo" ]]; then
        pacman -Si "$pkg" 2>/dev/null
    else
        yay -Si "$pkg" 2>/dev/null
    fi
}
