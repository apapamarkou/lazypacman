#!/usr/bin/env bash
# TUI interface

# Launch TUI
launch_tui() {
    local update_msg=""
    if check_updates; then
        update_msg=" | Updates available — Ctrl+U"
    fi
    
    while true; do
        local selected
        selected=$(get_all_packages | while read -r pkg source; do
            format_package_line "$pkg" "$source"
        done | fzf \
            --ansi \
            --layout=reverse \
            --height=24 \
            --border \
            --preview-window=right \
            --preview "bash -c 'source \"$MODULE_DIR/core/loader.sh\"; MODULE_DIR=\"$MODULE_DIR\"; require core/config; require core/colors; require core/utils; require pacman/pacman; require tui/preview; generate_preview \"{}\"'" \
            --header "Package Manager${update_msg} | Enter: install/remove | Ctrl+U: update | Ctrl+O: clean orphans | Ctrl+B: PKGBUILD | Ctrl+Q: quit" \
            --bind "enter:execute(bash -c 'source \"$MODULE_DIR/core/loader.sh\"; MODULE_DIR=\"$MODULE_DIR\"; require core/config; require core/colors; require core/utils; require pacman/pacman; require tui/actions; handle_package_action \"{}\"')" \
            --bind "ctrl-u:execute(bash -c 'source \"$MODULE_DIR/core/loader.sh\"; MODULE_DIR=\"$MODULE_DIR\"; require core/config; require system/updates; perform_update; read -rp \"Press Enter to continue...\"')" \
            --bind "ctrl-o:execute(bash -c 'source \"$MODULE_DIR/core/loader.sh\"; MODULE_DIR=\"$MODULE_DIR\"; require system/orphan_cleaner; clean_orphans')" \
            --bind "ctrl-b:execute(bash -c 'source \"$MODULE_DIR/core/loader.sh\"; MODULE_DIR=\"$MODULE_DIR\"; require tui/preview; preview_pkgbuild \$(echo \"{}\" | awk \"{print \\\$3}\")')" \
            --bind "ctrl-q:abort" \
            --bind "esc:abort")
        
        [[ -z "$selected" ]] && break
    done
}
