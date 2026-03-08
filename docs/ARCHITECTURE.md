# lazypacman - Project Overview

## Architecture

This project follows a **modular Bash architecture** with a custom module loader system.

### Module System

The `core/loader.sh` implements a `require()` function that:
- Loads modules by name (e.g., `require core/config`)
- Prevents duplicate imports using an associative array
- Provides clear error messages for missing modules

### Module Organization

```
src/
├── pkg                    # Main entry point
├── core/                  # Core functionality
│   ├── loader.sh         # Module loader
│   ├── config.sh         # Configuration constants
│   ├── colors.sh         # ANSI color codes
│   └── utils.sh          # Utility functions
├── cache/                 # Caching system
│   └── cache.sh          # Package cache management
├── cli/                   # CLI interface
│   ├── parser.sh         # Argument parser
│   ├── commands.sh       # Command implementations
│   └── help.sh           # Help text
├── tui/                   # TUI interface
│   ├── tui.sh            # Main TUI launcher
│   ├── preview.sh        # Preview generation
│   └── actions.sh        # User actions
├── pacman/                # Package operations
│   └── pacman.sh         # Pacman/yay wrappers
└── system/                # System operations
    ├── dependencies.sh   # Dependency checking
    ├── updates.sh        # Update management
    └── orphan_cleaner.sh # Orphan removal
```

## Key Features

### 1. Minimal Cache + Lazy Preview
- **Minimal cache**: Only package names and sources (~3 MB for 100k packages)
- **Lazy preview**: Dependencies and metadata fetched on-demand
- **Fast startup**: < 1 second even with massive package lists
- **Colored preview**: Syntax-highlighted package info with tree visualization
- Package cache: `~/.cache/lazypacman/packages.ndjson` (rebuilt daily)
- Update cache: `~/.cache/lazypacman/update_check` (6 hour interval)

### 2. Multi-Package Operations
- Install/remove multiple packages in one command
- Example: `pkg install vim git curl htop`

### 3. Smart CLI Features
- **Info command**: `pkg info <package>` shows detailed package information
- **Auto-paging**: Search results >24 lines automatically use `most` pager
- **Single-key prompts**: Y/N questions respond to single keypress

### 2. Dual Interface
- **TUI Mode**: Interactive fzf-based interface (no arguments)
- **CLI Mode**: Fast command-line operations (with arguments)

### 3. Safety Features
- `set -euo pipefail` in all scripts
- Reverse dependency warnings before removal
- Confirmation prompts for destructive operations

### 4. AUR Integration
- Seamless yay integration
- Optional PKGBUILD preview (Ctrl+B)
- Automatic source detection (repo vs AUR)

## Code Statistics

- Total lines: ~516
- Modules: 15
- Average module size: ~34 lines
- Main entry point: 38 lines

## Installation Methods

1. **Local**: `./install` (creates symlink)
2. **Remote**: `curl -fsSL <url>/install.sh | bash` (clones repo)

## Testing

Basic test suite in `tests/run_tests.sh` validates:
- Module loader functionality
- Function existence
- Module dependencies

## Dependencies

Required: `pacman`, `yay`, `fzf`, `jq`, `curl`

All checked at runtime by `system/dependencies.sh`
