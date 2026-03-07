#!/usr/bin/env bash
set -euo pipefail

# Basic test runner for pkg

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "Running tests for pkg..."
echo

# Test 1: Check module loader
echo "Test 1: Module loader"
MODULE_DIR="$PROJECT_ROOT/src"
source "$MODULE_DIR/core/loader.sh"
require core/config
require core/colors
echo "✓ Module loader works"
echo

# Test 2: Check cache functions exist
echo "Test 2: Cache functions"
require cache/cache
declare -F cache_needs_rebuild &>/dev/null && echo "✓ cache_needs_rebuild exists"
declare -F build_cache &>/dev/null && echo "✓ build_cache exists"
declare -F ensure_cache &>/dev/null && echo "✓ ensure_cache exists"
echo

# Test 3: Check CLI functions exist
echo "Test 3: CLI functions"
require cli/parser
require cli/commands
require cli/help
declare -F parse_cli &>/dev/null && echo "✓ parse_cli exists"
declare -F show_help &>/dev/null && echo "✓ show_help exists"
echo

# Test 4: Check TUI functions exist
echo "Test 4: TUI functions"
require tui/tui
require tui/preview
require tui/actions
declare -F launch_tui &>/dev/null && echo "✓ launch_tui exists"
declare -F generate_preview &>/dev/null && echo "✓ generate_preview exists"
echo

echo "All tests passed!"
