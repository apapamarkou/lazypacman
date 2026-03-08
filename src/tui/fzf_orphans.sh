#!/usr/bin/env bash
# Orphan cleaner helper for fzf

MODULE_DIR="${MODULE_DIR:-$(dirname "$0")}"
source "$MODULE_DIR/core/loader.sh"

require core/prompt
require system/orphan_cleaner

clean_orphans
