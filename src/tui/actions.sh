#!/usr/bin/env bash
# TUI actions

# Handle package selection (install/remove)
handle_package_action() {
    local line="$1"
    local pkg
    pkg=$(echo "$line" | awk '{print $3}')
    
    [[ -z "$pkg" ]] && return
    
    if is_installed "$pkg"; then
        remove_package "$pkg"
    else
        read -rp "Install $pkg? (Y/N): " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            local source
            source=$(get_package_source "$pkg")
            
            if [[ "$source" == "repo" ]]; then
                sudo pacman -S --needed --noconfirm "$pkg"
            else
                yay -S --needed "$pkg"
            fi
        else
            echo "Cancelled."
        fi
    fi
    
    read -rp "Press Enter to continue..."
}
