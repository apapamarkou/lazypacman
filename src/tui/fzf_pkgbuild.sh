#!/usr/bin/env bash
# PKGBUILD preview helper for fzf

MODULE_DIR="${MODULE_DIR:-$(dirname "$0")}"
source "$MODULE_DIR/core/loader.sh"

require tui/preview

pkg=$(echo "$1" | awk '{print $3}')
preview_pkgbuild "$pkg"
