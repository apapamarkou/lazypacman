#!/usr/bin/env bash
# TUI preview generation - lazy on-demand loading

# Generate preview for package (called on-demand by fzf)
generate_preview() {
    local line="$1"
    local pkg
    pkg=$(echo "$line" | awk '{print $3}')
    
    [[ -z "$pkg" ]] && { echo "No package selected"; return; }
    
    # Colors for preview
    local C_CYAN="\033[0;36m"     # Cyan for field names
    local C_GREY="\033[0;37m"     # Light grey for field values
    local C_GREEN="\033[0;32m"    # Green
    local C_BOLD="\033[1m"        # Bold
    local C_DIM="\033[2m"         # Dim
    local C_RESET="\033[0m"       # Reset
    
    # Fetch package info on-demand
    local info
    info=$(get_package_info "$pkg" 2>/dev/null)
    
    if [[ -n "$info" ]]; then
        # Parse and colorize package info
        echo -e "${C_CYAN}╭────────────────────────────────────────${C_RESET}"
        echo "$info" | while IFS=: read -r field value; do
            if [[ -n "$field" && -n "$value" ]]; then
                # Field name in cyan, value in light grey
                echo -e "${C_CYAN}│${C_RESET} ${C_CYAN}${field}:${C_RESET}${C_GREY}${value}${C_RESET}"
            elif [[ -n "$field" ]]; then
                echo -e "${C_CYAN}│${C_RESET} ${C_GREY}${field}${C_RESET}"
            fi
        done
        echo -e "${C_CYAN}╰────────────────────────────────────────${C_RESET}"
        echo
        
        # Show dependency tree only if package is installed
        if pacman -Q "$pkg" &>/dev/null; then
            echo -e "${C_CYAN}▶ Dependency Tree${C_RESET}"
            pactree "$pkg" 2>/dev/null | while IFS= read -r line; do
                if [[ "$line" == "$pkg" ]]; then
                    echo -e "  ${C_BOLD}${C_GREEN}$line${C_RESET}"
                else
                    echo -e "  ${C_DIM}$line${C_RESET}"
                fi
            done || echo -e "  ${C_DIM}(error reading tree)${C_RESET}"
        else
            echo -e "${C_CYAN}▶ Dependencies${C_RESET}"
            # Show dependencies from package info for non-installed packages
            local deps
            if pacman -Si "$pkg" &>/dev/null; then
                deps=$(pacman -Si "$pkg" | grep -E '^Depends On' | sed 's/Depends On *: //')
            elif command -v yay &>/dev/null; then
                deps=$(yay -Si "$pkg" 2>/dev/null | grep -E '^Depends On' | sed 's/Depends On *: //')
            fi
            
            if [[ -n "$deps" && "$deps" != "None" ]]; then
                # Parse and display each dependency vertically with install status
                echo "$deps" | tr ' ' '\n' | while read -r dep; do
                    [[ -z "$dep" ]] && continue
                    # Remove version constraints
                    dep_name=$(echo "$dep" | sed 's/[<>=].*//')
                    if pacman -Q "$dep_name" &>/dev/null; then
                        echo -e "  ${C_GREEN}[I]${C_RESET} $dep_name"
                    else
                        echo -e "  ${C_DIM}[_]${C_RESET} ${C_DIM}$dep_name${C_RESET}"
                    fi
                done
            else
                echo -e "  ${C_DIM}None${C_RESET}"
            fi
        fi
    else
        echo -e "${C_CYAN}╭────────────────────────────────────────${C_RESET}"
        echo -e "${C_CYAN}│${C_RESET} ${C_CYAN}Package:${C_RESET} ${C_GREY}$pkg${C_RESET}"
        echo -e "${C_CYAN}│${C_RESET} ${C_CYAN}Status:${C_RESET} ${C_GREY}Information not available${C_RESET}"
        echo -e "${C_CYAN}╰────────────────────────────────────────${C_RESET}"
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
