#!/usr/bin/env bash
set -euo pipefail

# Remote installation script for pkg
# Usage: curl -fsSL https://github.com/lazypacman/install.sh | bash

REPO_URL="https://github.com/apapamarkou/lazypacman.git"
INSTALL_DIR="$HOME/.local/share/pkg"
BIN_DIR="$HOME/.local/bin"

echo "Installing pkg from repository..."

# Check for git
if ! command -v git &>/dev/null; then
    echo "Error: git is required for installation"
    exit 1
fi

# Clone repository
if [[ -d "$INSTALL_DIR" ]]; then
    echo "Updating existing installation..."
    cd "$INSTALL_DIR"
    git pull
else
    echo "Cloning repository..."
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

# Run install script
cd "$INSTALL_DIR"
bash install

echo
echo "Installation complete! Run 'pkg' to start."
