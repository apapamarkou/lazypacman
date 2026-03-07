#!/usr/bin/env bash
# Action helper for fzf

MODULE_DIR="${MODULE_DIR:-$(dirname "$0")}"
source "$MODULE_DIR/core/loader.sh"

require core/config
require core/colors
require core/utils
require pacman/pacman
require tui/actions

handle_package_action "$1"
