#!/usr/bin/env bash
# Mock command helpers for testing

# Mock pacman -Slq (list repo packages)
mock_pacman_slq() {
    export -f pacman
    pacman() {
        if [[ "$1" == "-Slq" ]]; then
            cat << EOF
vim
neovim
git
curl
EOF
        fi
    }
}

# Mock yay -Slq (list AUR packages)
mock_yay_slq() {
    export -f yay
    yay() {
        if [[ "$1" == "-Slq" ]]; then
            cat << EOF
yay
paru
spotify
EOF
        fi
    }
}

# Mock pacman -Q (check installed)
mock_pacman_q() {
    export -f pacman
    pacman() {
        if [[ "$1" == "-Q" ]]; then
            case "$2" in
                vim|git) return 0 ;;
                *) return 1 ;;
            esac
        fi
    }
}

# Mock pacman -Si (package info)
mock_pacman_si() {
    export -f pacman
    pacman() {
        if [[ "$1" == "-Si" ]]; then
            cat << EOF
Name            : $2
Version         : 1.0.0
Description     : Test package
Architecture    : x86_64
Repository      : extra
Depends On      : glibc  bash
EOF
        fi
    }
}

# Reset all mocks
reset_mocks() {
    unset -f pacman yay pactree
}
