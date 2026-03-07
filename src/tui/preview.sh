#!/usr/bin/env bash
# TUI preview generation - lazy on-demand loading

# Generate preview for package (called on-demand by fzf)
generate_preview() {
    local line="$1"
    local pkg
    pkg=$(echo "$line" | awk '{print $3}')
    
    [[ -z "$pkg" ]] && { echo "No package selected"; return; }
    
    # Fetch package info on-demand
    local info
    info=$(get_package_info "$pkg" 2>/dev/null)
    
    if [[ -n "$info" ]]; then
        echo "$info"
        echo
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "Dependency tree:"
        pactree "$pkg" 2>/dev/null || echo "  (not available)"
    else
        echo "Package: $pkg"
        echo "Status: Information not available"
    fi
}

# Preview PKGBUILD for AUR package (Ctrl+B)
preview_pkgbuild() {
    local pkg="$1"
    [[ -z "$pkg" ]] && return
    
    local tmpdir
    tmpdir=$(mktemp -d)
    
    cd "$tmpdir" || return
    
    echo "Fetching PKGBUILD for $pkg..."
    if yay -G "$pkg" &>/dev/null && [[ -f "$pkg/PKGBUILD" ]]; then
        less "$pkg/PKGBUILD"
    else
        echo "PKGBUILD not available for $pkg"
        read -rp "Press Enter to continue..."
    fi
    
    cd - &>/dev/null
    rm -rf "$tmpdir"
}
