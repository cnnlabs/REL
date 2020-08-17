SHELL       := bash
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR  := $(realpath $(dir $(MKFILE_PATH)))

########################
# PYTHON CONFIGURATION #
########################

# Executables and default options
PYTHON    ?= python3
PIP       ?= $(PYTHON) -m pip
VENV      ?= $(PYTHON) -m virtualenv
PIP_OPTS  ?=
VENV_OPTS ?=

# Project directories
VENVDIR ?= venv

# Virtualenv enabled by default, set to 0 to disable
WITH_VENV ?= 1
ifneq (0, $(WITH_VENV))
VENVACTIVATE := test -d $(VENVDIR) || $(VENV) $(VENV_OPTS) $(VENVDIR); source $(VENVDIR)/bin/activate;
endif

###########
# TARGETS #
###########

.PHONY: deps clean clean-pycache clean-venv cleanall

deps:
	@$(VENVACTIVATE) $(PIP) $(PIP_OPTS) install -r requirements.txt

build:
	@$(VENVACTIVATE) $(PYTHON) setup.py sdist bdist_wheel

clean:
	@rm -rf build dist *.egg-info

clean-pycache:
	@find . -type f -name '*.py[co]' -delete -o -type d -name __pycache__ -delete

clean-venv:
	@rm -rf $(VENVDIR)

cleanall: clean clean-pycache clean-venv
