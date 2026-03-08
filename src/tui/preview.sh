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
        # Parse and colorize package info
        echo -e "${COLOR_CYAN}╭────────────────────────────────────────${COLOR_RESET}"
        mapfile -t lines <<< "$info"
        for line in "${lines[@]}"; do
            # Check if line contains a field (has colon)
            if [[ "$line" =~ ^([^:]+):(.*)$ ]]; then
                local field="${BASH_REMATCH[1]}"
                local value="${BASH_REMATCH[2]}"
                value="${value# }"  # Trim leading space
                
                # Special handling for "Depends On" field
                if [[ "$field" =~ "Depends On" ]]; then
                    echo -ne "${COLOR_CYAN}│${COLOR_RESET} ${COLOR_CYAN}${field}:${COLOR_RESET}"
                    # Color each dependency based on install status
                    if [[ -z "$value" || "$value" == "None" ]]; then
                        echo -e " ${COLOR_GREY}None${COLOR_RESET}"
                    else
                        for dep in $value; do
                            dep_name=$(echo "$dep" | sed 's/[<>=].*//')
                            if pacman -Q "$dep_name" &>/dev/null 2>&1; then
                                echo -ne " ${COLOR_GREEN}${dep}${COLOR_RESET}"
                            else
                                echo -ne " ${COLOR_GREY}${dep}${COLOR_RESET}"
                            fi
                        done
                        echo
                    fi
                else
                    # Field name in cyan, value in light grey
                    if [[ -z "$value" ]]; then
                        echo -e "${COLOR_CYAN}│${COLOR_RESET} ${COLOR_CYAN}${field}:${COLOR_RESET} ${COLOR_GREY}None${COLOR_RESET}"
                    else
                        echo -e "${COLOR_CYAN}│${COLOR_RESET} ${COLOR_CYAN}${field}:${COLOR_RESET} ${COLOR_GREY}${value}${COLOR_RESET}"
                    fi
                fi
            elif [[ -n "$line" ]]; then
                # Continuation line (no colon) - display as grey text with indent
                echo -e "${COLOR_CYAN}│${COLOR_RESET}   ${COLOR_GREY}${line}${COLOR_RESET}"
            fi
        done
        echo -e "${COLOR_CYAN}╰────────────────────────────────────────${COLOR_RESET}"
        echo
        
        # Show dependency tree only if package is installed
        if pacman -Q "$pkg" &>/dev/null; then
            echo -e "${COLOR_CYAN}▶ Dependency Tree${COLOR_RESET}"
            pactree "$pkg" 2>/dev/null | while IFS= read -r line; do
                if [[ "$line" == "$pkg" ]]; then
                    echo -e "  ${COLOR_BOLD}${COLOR_GREEN}$line${COLOR_RESET}"
                else
                    echo -e "  ${COLOR_DIM}$line${COLOR_RESET}"
                fi
            done || echo -e "  ${COLOR_DIM}(error reading tree)${COLOR_RESET}"
        else
            echo -e "${COLOR_CYAN}▶ Dependencies${COLOR_RESET}"
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
                        echo -e "  ${COLOR_GREEN}[I]${COLOR_RESET} $dep_name"
                    else
                        echo -e "  ${COLOR_DIM}[_]${COLOR_RESET} ${COLOR_DIM}$dep_name${COLOR_RESET}"
                    fi
                done
            else
                echo -e "  ${COLOR_DIM}None${COLOR_RESET}"
            fi
        fi
    else
        echo -e "${COLOR_CYAN}╭────────────────────────────────────────${COLOR_RESET}"
        echo -e "${COLOR_CYAN}│${COLOR_RESET} ${COLOR_CYAN}Package:${COLOR_RESET} ${COLOR_GREY}$pkg${COLOR_RESET}"
        echo -e "${COLOR_CYAN}│${COLOR_RESET} ${COLOR_CYAN}Status:${COLOR_RESET} ${COLOR_GREY}Information not available${COLOR_RESET}"
        echo -e "${COLOR_CYAN}╰────────────────────────────────────────${COLOR_RESET}"
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
