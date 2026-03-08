# Contributing to pkg

Thank you for your interest in contributing to pkg!

## Development Setup

1. Clone the repository:
```bash
git clone https://github.com/apapamarkou/lazypacman.git
cd pkg
```

2. Install locally:
```bash
./install
```

## Project Structure

- `src/core/` - Core functionality (config, colors, utils, loader)
- `src/cache/` - Package cache management
- `src/cli/` - CLI command implementations
- `src/tui/` - TUI interface and actions
- `src/pacman/` - Pacman/yay operations
- `src/system/` - System operations (updates, dependencies, orphans)
- `tests/` - Test files

## Coding Standards

- Use `set -euo pipefail` in all scripts
- Follow existing code style
- Add comments for complex logic
- Keep functions small and focused
- Use the module loader pattern for imports

## Testing

Run tests:
```bash
./tests/run_tests.sh
```

## Submitting Changes

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Reporting Issues

Please include:
- Your Arch Linux version
- Steps to reproduce
- Expected vs actual behavior
- Error messages if any
