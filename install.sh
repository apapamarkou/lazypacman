#!/usr/bin/env bash
set -euo pipefail

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
# Remote installation script for lazypacman
# Usage: curl -fsSL https://raw.githubusercontent.com/apapamarkou/lazypacman/main/install.sh | bash

REPO_URL="https://github.com/apapamarkou/lazypacman.git"
INSTALL_DIR="$HOME/.local/share/lazypacman"
BIN_DIR="$HOME/.local/bin"

echo "Installing lazypacman from repository..."

# Check for git
if ! command -v git &>/dev/null; then
    echo -n "git is required. Install it? (Y/N): "
    read -n 1 -r response
    echo
    if [[ "$response" =~ ^[Yy]$ ]]; then
        sudo pacman -S --needed git
    else
        echo "Installation cancelled."
        exit 1
    fi
fi

# Clone or update repository
if [[ -d "$INSTALL_DIR" ]]; then
    echo "Updating existing installation..."
    cd "$INSTALL_DIR"
    git pull
    
    # Clean up - keep only src/ and uninstall
    find . -maxdepth 1 -not -name '.' -not -name '..' -not -name 'src' -not -name 'uninstall' -not -name '.git' -exec rm -rf {} +
else
    echo "Cloning repository..."
    git clone "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    
    # Clean up - keep only src/ and uninstall
    find . -maxdepth 1 -not -name '.' -not -name '..' -not -name 'src' -not -name 'uninstall' -not -name '.git' -exec rm -rf {} +
fi

# Create symlink
mkdir -p "$BIN_DIR"
ln -sf "$INSTALL_DIR/src/pkg" "$BIN_DIR/pkg"
chmod +x "$INSTALL_DIR/src/pkg"

echo
echo "✓ Installation complete! Run 'pkg' to start."
