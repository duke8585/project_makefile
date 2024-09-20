# inspired by https://github.com/idealo/shalmaneser-parquet-file-merge/blob/main/Makefile
# and https://github.com/idealo/die-monte-carlo-dq/blob/main/Makefile

PYTHON = python3
PYTHON_VERSION = 3.11.3
VENV = .venv

.PHONY: all
DEFAULT_GOAL: setup
LOOKBACK_DAYS?=14

setup: install_pyenv_version venv

venv: $(VENV)/touchfile # wrapper for the one below

get_pyenv:
	@echo "installing pyenv via homebrew"
	brew install pyenv

install_pyenv_version:
	@echo "installing python$(PYTHON_VERSION) via pyenv"
	pyenv install $(PYTHON_VERSION) || true
	pyenv local $(PYTHON_VERSION)
	@# NOTE avoid error 1 on N exit

pip-install: # NOTE only for GH actions
	pip install -r requirements.txt && pip install -r requirements-dev.txt

# only when requirements change: https://stackoverflow.com/questions/24736146/how-to-use-virtualenv-in-makefile
$(VENV)/touchfile: requirements.txt requirements-dev.txt
	@if [ -f .python-version ]; then \
		echo "Creating virtual environment and installing dependencies"; \
		$(PYTHON) -m venv $(VENV) || { echo "!!!no $(PYTHON) found"; exit 1; }; \
		. $(VENV)/bin/activate && pip install --upgrade pip && \
		pip install -r requirements.txt && pip install -r requirements-dev.txt; \
		touch $(VENV)/touchfile; \
	else \
		echo "!!!no .python-version found, see 'make install_pyenv_version'"; exit 1; \
	fi

update: # to force the upper
	. $(VENV)/bin/activate && pip install --upgrade pip \
	&& pip install -r requirements.txt && pip install -r requirements_dev.txt

format:
	nbqa isort .
	nbqa black . --exclude '/(outputs|\.ipynb_checkpoints)/'
	nbqa autoflake . -i --remove-all-unused-imports --exclude '/(outputs|\.ipynb_checkpoints)/'

cleanup:
	@echo "Cleaning up the envs / temps."
	@rm -rf $(VENV)/
	# TODO more to be deleted?
