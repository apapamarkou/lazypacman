#!/usr/bin/env bash
# Configuration and constants

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/pkg"
CACHE_FILE="$CACHE_DIR/packages.ndjson"
UPDATE_CHECK_FILE="$CACHE_DIR/update_check"
CACHE_MAX_AGE=$((24 * 3600))  # 24 hours
UPDATE_CHECK_INTERVAL=$((6 * 3600))  # 6 hours
