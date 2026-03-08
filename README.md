# lazypacman

Fast TUI + CLI package manager wrapper for Arch Linux

A modern terminal interface for managing packages using pacman, yay, and fzf.

## Features

- **Interactive TUI** - Browse and manage packages with a beautiful terminal interface
- **Fast CLI** - Quick commands for common operations with multi-package support
- **Minimal Cache** - Lightweight cache (name + source only) for instant startup
- **Lazy Preview** - Package details loaded on-demand for optimal performance
- **Colored Preview** - Syntax-highlighted package info with dependency tree visualization
- **AUR Support** - Seamless integration with yay for AUR packages
- **Dependency Warnings** - Shows reverse dependencies before removal
- **Update Notifications** - Lazy update checking every 6 hours
- **Orphan Cleaning** - Easy removal of unused dependencies
- **PKGBUILD Preview** - Inspect AUR build scripts before installation
- **Smart Paging** - Automatic pager for long search results

## Installation

### Quick Install (curl)

```bash
curl -fsSL https://raw.githubusercontent.com/apapamarkou/lazypacman/main/install.sh | bash
```

### Manual Install

```bash
git clone https://github.com/apapamarkou/lazypacman.git
cd lazypacman
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
- `most` - Pager for viewing files (optional, falls back to less)
- `pacman-contrib` - For dependency tree visualization (optional)

Install missing dependencies:

```bash
sudo pacman -S fzf jq curl most pacman-contrib
```

```bash
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

## Usage

### Interactive TUI

Launch the interactive interface:

```bash
pkg
```

### CLI Commands

```bash
pkg install <package>...       # Install one or more packages
pkg i <package>...             # Short form

pkg remove <package>...        # Remove one or more packages
pkg r <package>...             # Short form

pkg info <package>             # Show package information

pkg search <term>              # Search packages (auto-paged if >24 results)
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

Install single package:
```bash
pkg install neovim
```

Install multiple packages:
```bash
pkg install vim git curl htop
```

Get package info:
```bash
pkg info firefox
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

## Performance

lazypacman uses a **minimal cache + lazy preview** architecture:

- **Minimal cache**: Only package names and sources stored (~3 MB)
- **Lazy preview**: Dependencies and metadata fetched on-demand when selected
- **Fast startup**: < 1 second even with 100k+ packages

Cache locations:
- Package cache: `~/.cache/lazypacman/packages.ndjson` (rebuilt daily)
- Update cache: `~/.cache/lazypacman/update_check` (6 hour interval)

See [PERFORMANCE.md](PERFORMANCE.md) for detailed benchmarks.

## Uninstall

```bash
./uninstall
```

Or manually:

```bash
rm ~/.local/bin/pkg
rm -rf ~/.cache/lazypacman
rm -rf ~/.local/share/lazypacman
```

## License

GPL-3.0

## Contributing

Contributions welcome! Please open an issue or pull request.
