# Modern Python project Makefile using uv and pyenv
# Inspired by https://github.com/idealo/shalmaneser-parquet-file-merge/blob/main/Makefile
# and https://github.com/idealo/die-monte-carlo-dq/blob/main/Makefile

PYTHON_VERSION = 3.11.3
APP_NAME = "my-fancy-app"

.PHONY: all
DEFAULT_GOAL: setup

# Complete setup: install python version and sync dependencies
setup: install_pyenv_version sync

# Install pyenv (if needed)
get_pyenv:
	@echo "Installing pyenv via homebrew"
	brew install pyenv

# Install specific Python version via pyenv
install_pyenv_version:
	@echo "Installing python $(PYTHON_VERSION) via pyenv"
	pyenv install $(PYTHON_VERSION) || true
	pyenv local $(PYTHON_VERSION)

# Install uv (if not already installed)
get_uv:
	@echo "Installing uv"
	curl -LsSf https://astral.sh/uv/install.sh | sh

# Sync dependencies (creates venv automatically if needed)
sync:
	@echo "Syncing dependencies with uv"
	uv sync --extra dev

# Update dependencies
update:
	@echo "Updating dependencies"
	uv sync --extra dev --upgrade

# Add a new dependency
add:
	@echo "Usage: make add PACKAGE=package_name"
	@echo "Example: make add PACKAGE=requests"
ifdef PACKAGE
	uv add $(PACKAGE)
endif

# Add a dev dependency  
add-dev:
	@echo "Usage: make add-dev PACKAGE=package_name"
	@echo "Example: make add-dev PACKAGE=pytest-cov"
ifdef PACKAGE
	uv add --dev $(PACKAGE)
endif

# Remove a dependency
remove:
	@echo "Usage: make remove PACKAGE=package_name"
	@echo "Example: make remove PACKAGE=requests"
ifdef PACKAGE
	uv remove $(PACKAGE)
endif

# Run tests
test:
	uv run pytest

# Format code
format:
	uv run black .
	uv run autoflake --in-place --remove-all-unused-imports --recursive .

# Lint code
lint:
	uv run pylint **/*.py

# Run a Python script
run:
	@echo "Usage: make run SCRIPT=script_name.py"
	@echo "Example: make run SCRIPT=main.py"
ifdef SCRIPT
	uv run python $(SCRIPT)
endif

# Clean up
cleanup:
	@echo "Cleaning up the virtual environment"
	@rm -rf .venv/
	@rm -rf .pytest_cache/
	@rm -rf __pycache__/
	@find . -name "*.pyc" -delete
	@find . -name "*.pyo" -delete

# Show project info
info:
	@echo "Project: $(APP_NAME)"
	@echo "Python version: $(PYTHON_VERSION)"
	@echo "Dependencies:"
	@uv tree 2>/dev/null || echo "Run 'make sync' first"

# Lock dependencies (create uv.lock)
lock:
	uv lock