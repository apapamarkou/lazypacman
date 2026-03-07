# pkg - Quick Reference

## Installation
```bash
# Local
git clone <repo> && cd pkg && ./install

# Remote
curl -fsSL <url>/install.sh | bash
```

## CLI Commands
```bash
pkg                    # Launch TUI
pkg i <package>        # Install
pkg r <package>        # Remove
pkg s <term>           # Search
pkg sno <term>         # Search names only
pkg u                  # Update system
pkg co                 # Clean orphans
pkg h                  # Help
```

## TUI Keys
```
Enter      Install/remove
Ctrl+U     Update
Ctrl+O     Clean orphans
Ctrl+B     Preview PKGBUILD
Ctrl+Q     Quit
ESC        Quit
```

## Files
```
~/.local/bin/pkg              # Executable
~/.cache/pkg/packages.ndjson  # Package cache (24h)
~/.cache/pkg/update_check     # Update cache (6h)
```

## Module Structure
```
require core/config           # Load config
require cache/cache           # Load cache functions
require cli/parser            # Load CLI parser
```

## Development
```bash
./tests/run_tests.sh          # Run tests
./uninstall                   # Uninstall
```
