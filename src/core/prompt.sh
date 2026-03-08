#!/usr/bin/env bash
# Prompt utilities

# Ask Y/N question with single keypress
ask_yn() {
    local prompt="$1"
    local key
    
    echo -n "$prompt"
    read -n 1 -r key
    echo
    
    [[ "$key" =~ ^[Yy]$ ]]
}
