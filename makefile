SHELL = /bin/bash

UNAME_S := $(shell uname -s)

# Set shell defaults to support Susudoio
set_shell_defaults:
ifneq (,$(wildcard $HOME/.config/set_shell_defaults.ok))
	$(BASHLIB_INCLUDES_DIR)/set_shell_defaults.sh
endif

# Optionally install Susudoio
susudoio: set_shell_defaults
ifeq ($(UNAME_S),Darwin)
ifeq ($(shell which susudoio),)
	$(BASHLIB_INCLUDES_DIR)/macos_install_susudoio.sh
endif
endif # ifeq ($(UNAME_S),Darwin)

# Prerequisites
prerequisites:
ifeq ($(UNAME_S),Darwin)
ifeq ($(shell which brew),)
	$(BASHLIB_INCLUDES_DIR)/macos_install_brew.sh
endif
ifeq ($(shell which ansible),)
	$(BASHLIB_INCLUDES_DIR)/macos_install_ansible.sh
endif
endif # ifeq ($(UNAME_S),Darwin)

# Install
install: prerequisites susudoio
	@echo "Installing."
