#!/usr/bin/env bash
set -euo pipefail

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
