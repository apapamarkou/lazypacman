#!/usr/bin/env bash
# Update helper for fzf

MODULE_DIR="${MODULE_DIR:-$(dirname "$0")}"
source "$MODULE_DIR/core/loader.sh"

require core/config
require system/updates

perform_update
read -rp "Press Enter to continue..."
