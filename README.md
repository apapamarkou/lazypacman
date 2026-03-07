# pkg

Fast TUI + CLI package manager wrapper for Arch Linux

A modern terminal interface for managing packages using pacman, yay, and fzf.

## Features

- **Interactive TUI** - Browse and manage packages with a beautiful terminal interface
- **Fast CLI** - Quick commands for common operations
- **Smart Caching** - Daily package cache for instant searches
- **AUR Support** - Seamless integration with yay for AUR packages
- **Dependency Warnings** - Shows reverse dependencies before removal
- **Update Notifications** - Lazy update checking every 6 hours
- **Orphan Cleaning** - Easy removal of unused dependencies
- **PKGBUILD Preview** - Inspect AUR build scripts before installation

## Installation

### Quick Install (curl)

```bash
curl -fsSL https://raw.githubusercontent.com/apapamarkou/pkg/main/install.sh | bash
```

### Manual Install

```bash
git clone https://github.com/apapamarkou/pkg.git
cd pkg
./install
```

Ensure `~/.local/bin` is in your PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Dependencies

- `pacman` - Package manager
- `yay` - AUR helper
- `fzf` - Fuzzy finder
- `jq` - JSON processor
- `curl` - HTTP client

Install missing dependencies:

```bash
sudo pacman -S fzf jq curl
yay -S yay
```

## Usage

### Interactive TUI

Launch the interactive interface:

```bash
pkg
```

### CLI Commands

```bash
pkg install <package>          # Install a package
pkg i <package>                # Short form

pkg remove <package>           # Remove a package
pkg r <package>                # Short form

pkg search <term>              # Search packages
pkg s <term>                   # Short form

pkg search-names-only <term>   # Search names only
pkg sno <term>                 # Short form

pkg update                     # Update system
pkg u                          # Short form

pkg clean-orphans              # Remove orphan packages
pkg co                         # Short form

pkg help                       # Show help
pkg h                          # Short form
```

## TUI Key Bindings

| Key | Action |
|-----|--------|
| `Enter` | Install/remove selected package |
| `Ctrl+U` | System update |
| `Ctrl+O` | Clean orphan packages |
| `Ctrl+B` | Preview PKGBUILD (AUR) |
| `Ctrl+Q` / `ESC` | Exit |

## Examples

Install neovim:
```bash
pkg install neovim
```

Search for browsers:
```bash
pkg search firefox
```

Update system:
```bash
pkg update
```

Interactive mode:
```bash
pkg
```

## Cache

Package cache is stored at `~/.cache/pkg/packages.ndjson` and rebuilt daily.

Update check cache is stored at `~/.cache/pkg/update_check` and refreshed every 6 hours.

## Uninstall

```bash
./uninstall
```

Or manually:

```bash
rm ~/.local/bin/pkg
rm -rf ~/.cache/pkg
rm -rf ~/.local/share/pkg
```

## License

MIT

## Contributing

Contributions welcome! Please open an issue or pull request.
