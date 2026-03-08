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
# TUI interface - fast startup with lazy preview

# Launch TUI with minimal cache and on-demand preview
launch_tui() {
    local update_msg=""
    if check_updates; then
        update_msg=" | Updates available — Ctrl+U"
    fi
    
    # Ensure minimal cache exists
    ensure_cache
    
    # Build installed packages lookup (once) - use associative array for O(1) lookup
    declare -A installed_map
    while read -r pkg; do
        installed_map[$pkg]=1
    done < <(pacman -Qq)
    
    while true; do
        local selected
        # Stream packages directly from cache, format on-the-fly
        selected=$(jq -r '"\(.name) \(.source)"' "$CACHE_FILE" | while read -r pkg source; do
            # Fast O(1) lookup
            local is_installed=0
            [[ -n "${installed_map[$pkg]:-}" ]] && is_installed=1
            format_package_line "$pkg" "$source" "$is_installed"
        done | MODULE_DIR="$MODULE_DIR" fzf \
            --ansi \
            --layout=reverse \
            --height=24 \
            --border \
            --preview-window=right:60% \
            --preview "$MODULE_DIR/tui/fzf_preview.sh {}" \
            --header "$(echo -e "${COLOR_CYAN}${COLOR_BOLD}Package Manager${update_msg}${COLOR_RESET}\n${COLOR_DIM}Enter: install/remove | Ctrl+U: update | Ctrl+O: orphans\nCtrl+B: PKGBUILD | Ctrl+Q: quit${COLOR_RESET}")" \
            --bind "enter:execute($MODULE_DIR/tui/fzf_action.sh {})" \
            --bind "ctrl-u:execute($MODULE_DIR/tui/fzf_update.sh)" \
            --bind "ctrl-o:execute($MODULE_DIR/tui/fzf_orphans.sh)" \
            --bind "ctrl-b:execute($MODULE_DIR/tui/fzf_pkgbuild.sh {})" \
            --bind "ctrl-q:abort" \
            --bind "esc:abort")
        
        [[ -z "$selected" ]] && break
    done
}
