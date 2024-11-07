# inspired by https://github.com/idealo/shalmaneser-parquet-file-merge/blob/main/Makefile
# and https://github.com/idealo/die-monte-carlo-dq/blob/main/Makefile

PYTHON = python3
PYTHON_VERSION = 3.11.3
VENV = .venv
APP_NAME = "my-fancy-app"


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

# pip-install: # NOTE only for GH actions
# 	pip install -r requirements.txt && pip install -r requirements-dev.txt

# only when requirements change: https://stackoverflow.com/questions/24736146/how-to-use-virtualenv-in-makefile
$(VENV)/touchfile: requirements.txt requirements-dev.txt
	@if [ -f .python-version ]; then \
		echo "Creating virtual environment and installing dependencies"; \
		$(PYTHON) -m venv $(VENV) || { echo "!!!no $(PYTHON) found"; exit 1; }; \
		. $(VENV)/bin/activate && pip install --upgrade pip && \
		pip install -r requirements.txt && pip install -r requirements-dev.txt; \
		touch $(VENV)/touchfile; \
		rm -rf .python-version; \
	else \
		echo "!!!no .python-version found, see 'make install_pyenv_version'"; exit 1; \
	fi

update: # to force the upper
	. $(VENV)/bin/activate && pip install --upgrade pip \
	&& pip install -r requirements.txt && pip install -r requirements-dev.txt

cleanup:
	@echo "Cleaning up the envs / temps."
	@rm -rf $(VENV)/
	# TODO more to be deleted?



# # NOTE docker part, only as needed

# d_init:
# 	brew install --cask docker && \
# 	docker run hello-world && \
# 	echo "we are set :)"

# d_start:
# 	open -a docker
# 	echo "we are set :)"

# d_build:
# 	docker build . -t $(APP_NAME)

# d_run: d_build
# 	docker run -d -p 5000:5000 $(APP_NAME)

# d_list:
# 	docker ps

# d_kill:
# 	docker kill $$(docker ps | grep $(APP_NAME) | cut -d" " -f 1)

# d_ssh:
# 	docker exec -it $$(docker ps | grep $(APP_NAME) | cut -d" " -f 1) bash

# d_ssh_root:
# 	docker exec -it -u root $$(docker ps | grep $(APP_NAME) | cut -d" " -f 1) bash

# d_clean_all: d_clean_images d_clean_containers d_clean_volumes

# d_clean_images:
# 	docker image prune -a

# d_clean_containers:
# 	docker container prune

# d_clean_volumes:
# 	docker system prune --volumes