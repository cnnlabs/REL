SHELL       := bash
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR  := $(realpath $(dir $(MKFILE_PATH)))

########################
# PYTHON CONFIGURATION #
########################

# Executables and default options
PYTHON    ?= python3
PIP       ?= pip3
VENV      ?= virtualenv
PIP_OPTS  ?=
VENV_OPTS ?=

# Project directories
VENVDIR ?= venv

# Virtualenv enabled by default, set to 0 to disable
WITH_VENV ?= 1

# Create and activate virtualenv
ifneq (0, $(WITH_VENV))
VENVACTIVATE := [[ ! -d $(VENVDIR) ]] && $(VENV) $(VENV_OPTS) $(VENVDIR) || true; \
	source $(VENVDIR)/bin/activate;
endif

###########
# TARGETS #
###########

.PHONY: install
install:
	@$(VENVACTIVATE) $(PIP) $(PIP_OPTS) install -r requirements.txt

.PHONY: clean
clean:
	@rm -rf build dist REL.egg-info

.PHONY: clean-venv
clean-venv:
	@rm -rf $(VENVDIR)

.PHONY: cleanall
cleanall: clean clean-venv

.PHONY: package
package:
	@$(VENVACTIVATE) $(PYTHON) setup.py sdist bdist_wheel
