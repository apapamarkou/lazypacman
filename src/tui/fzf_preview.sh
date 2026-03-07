#!/usr/bin/env bash
# Preview helper for fzf

MODULE_DIR="${MODULE_DIR:-$(dirname "$0")}"
source "$MODULE_DIR/core/loader.sh"

require core/config
require core/colors
require core/utils
require pacman/pacman
require tui/preview

generate_preview "$1"
