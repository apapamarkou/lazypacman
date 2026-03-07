#!/usr/bin/env bash
# TUI preview generation

# Generate preview for package
generate_preview() {
    local line="$1"
    local pkg
    pkg=$(echo "$line" | awk '{print $3}')
    
    [[ -z "$pkg" ]] && return
    
    local info
    info=$(get_package_info "$pkg")
    
    if [[ -n "$info" ]]; then
        echo "$info"
        echo
        echo "Dependency tree:"
        pactree "$pkg" 2>/dev/null || echo "Not available"
    else
        echo "Package information not available"
    fi
}

# Preview PKGBUILD for AUR package
preview_pkgbuild() {
    local pkg="$1"
    local tmpdir
    tmpdir=$(mktemp -d)
    
    cd "$tmpdir" || return
    yay -G "$pkg" &>/dev/null
    
    if [[ -f "$pkg/PKGBUILD" ]]; then
        less "$pkg/PKGBUILD"
    else
        echo "PKGBUILD not available"
        read -rp "Press Enter to continue..."
    fi
    
    cd - &>/dev/null
    rm -rf "$tmpdir"
}
