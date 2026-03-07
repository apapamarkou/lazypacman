#!/usr/bin/env bash
# Configuration and constants

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/lazypacman"
CACHE_FILE="$CACHE_DIR/packages.ndjson"  # Minimal cache: name + source only
UPDATE_CHECK_FILE="$CACHE_DIR/update_check"
CACHE_MAX_AGE=$((24 * 3600))  # 24 hours
UPDATE_CHECK_INTERVAL=$((6 * 3600))  # 6 hours

# Performance: minimal cache for fast startup, lazy preview generation
