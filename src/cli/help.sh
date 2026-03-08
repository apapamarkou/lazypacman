#!/usr/bin/env bash
# Help text

show_help() {
    cat << 'EOF'
pkg - Fast TUI + CLI package manager wrapper for Arch Linux

USAGE:
    pkg                          Launch interactive TUI
    pkg <command> [args]         Run CLI command

COMMANDS:
    install, i <package>...      Install package(s)
    remove, r <package>...       Remove package(s)
    info <package>               Show package information
    search, s <term>             Search packages
    search-names-only, sno <term> Search package names only
    update, u                    Update system
    clean-orphans, co            Remove orphan packages
    help, h                      Show this help

TUI KEY BINDINGS:
    Enter       Install/remove package
    Ctrl+U      System update
    Ctrl+O      Clean orphan packages
    Ctrl+B      Preview PKGBUILD (AUR)
    Ctrl+Q/ESC  Exit

EXAMPLES:
    pkg install neovim
    pkg install vim git curl
    pkg info firefox
    pkg search firefox
    pkg update
EOF
}
