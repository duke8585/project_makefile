# Modern Python Project Setup

A Python project template using modern tooling: `uv` for fast dependency management and `pyenv` for Python version management.

## Quick Start

```bash
# 1. Install Python version (if using pyenv)
make install_pyenv_version

# 2. Install uv (if not already installed)
make get_uv

# 3. Set up project and dependencies
make setup
```

## What's Different

This setup uses **`uv`** instead of traditional `pip + venv`, providing:
- ⚡ **10-100x faster** dependency resolution and installation
- 🔒 **Automatic virtual environment** management
- 📦 **Modern dependency specification** via `pyproject.toml`
- 🎯 **Simplified workflow** with fewer commands

## Common Commands

```bash
# Install dependencies
make sync

# Run scripts
uv run python my_script.py
# or via make:
make run SCRIPT=my_script.py

# Add dependencies
make add PACKAGE=requests
make add-dev PACKAGE=pytest-cov

# Development tasks
make test          # Run tests
make format        # Format code with black
make lint          # Lint with pylint

# Project info
make info          # Show dependencies and project info
```

## Auto-Activation

For auto-activating the environment when entering the directory, if using oh-my-zsh, add `virtualenv-autodetect` to your plugins in `~/.zshrc`:

```bash
plugins=(
    ...
    virtualenv-autodetect # ⬅️ this
    ...
)
```

## Dependencies

Dependencies are managed in `pyproject.toml` instead of separate requirements files. The project automatically handles both production and development dependencies.