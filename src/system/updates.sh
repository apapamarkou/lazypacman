#!/usr/bin/env bash
# Update checking

# Check if update check is needed
update_check_needed() {
    [[ ! -f "$UPDATE_CHECK_FILE" ]] && return 0
    
    local check_age=$(($(date +%s) - $(stat -c %Y "$UPDATE_CHECK_FILE" 2>/dev/null || echo 0)))
    [[ $check_age -gt $UPDATE_CHECK_INTERVAL ]] && return 0
    
    return 1
}

# Check for available updates
check_updates() {
    if update_check_needed; then
        mkdir -p "$CACHE_DIR"
        if checkupdates &>/dev/null; then
            echo "1" > "$UPDATE_CHECK_FILE"
        else
            echo "0" > "$UPDATE_CHECK_FILE"
        fi
    fi
    
    [[ -f "$UPDATE_CHECK_FILE" ]] && [[ "$(cat "$UPDATE_CHECK_FILE")" == "1" ]]
}

# Perform system update
perform_update() {
    yay -Syu
    echo "0" > "$UPDATE_CHECK_FILE"
}
