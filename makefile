SHELL = /bin/bash

UNAME_S := $(shell uname -s)

# Generate ssh key and display pubkey.
ssh_keygen:
	@echo "======== SSH Keygen ==================================================="
	$(BASHLIB_SRC_DIR)/ssh_keygen.sh

# Set shell defaults to support Susudoio
set_shell_defaults:
ifneq (,$(wildcard $(HOME)/.config/set_shell_defaults.ok))
	@echo "======== Ensuring dotfile defaults. ==================================="
	$(BASHLIB_SRC_DIR)/set_shell_defaults.sh
endif

# Prerequisites
prerequisites:
ifeq ($(UNAME_S),Darwin)
	@echo "======== Ensuring Darwin prerequisites. ==============================="
ifeq ($(shell which brew),)
	@echo "* Installing homebrew."
	$(BASHLIB_SRC_DIR)/macos_install_brew.sh
endif
ifeq ($(shell which ansible),)
	@echo "* Installing ansible."
	$(BASHLIB_SRC_DIR)/macos_install_ansible.sh
endif
ifeq ($(shell which susudoio),)
	@echo "* Installing susudoio."
	$(BASHLIB_SRC_DIR)/macos_install_susudoio.sh
endif
endif # ifeq ($(UNAME_S),Darwin)

# Install
install: ssh_keygen set_shell_defaults prerequisites
