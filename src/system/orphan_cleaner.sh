#!/usr/bin/env bash
# Orphan package cleaner

# Clean orphan packages
clean_orphans() {
    local orphans
    orphans=$(pacman -Qtdq 2>/dev/null)
    
    if [[ -z "$orphans" ]]; then
        echo "No orphan packages found."
        return 0
    fi
    
    echo "Orphan packages:"
    echo "$orphans"
    echo
    if ask_yn "Remove these packages? (Y/N): "; then
        sudo pacman -Rns $orphans
    else
        echo "Cancelled."
    fi
}
