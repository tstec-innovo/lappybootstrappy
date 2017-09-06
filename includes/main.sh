#!/usr/bin/env bash
# <<YAMLDOC
# namespace: /neutron37/ansible_content
# description: "Ansible Content Project"
# copyright: "Neutron37"
# authors: "neutron37@protonmail.com"
# tags: bootstrap macbook laptop ansible docker
# YAMLDOC

ADMIN_USER="$1"
ADMIN_PASS="$2"
TARGET_USER="$3"

set -u
set -o pipefail

###############
## Constants ##
###############
# Reference: https://stackoverflow.com/a/246128
readonly INCLUDES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly HOME_DIR="${INCLUDES_DIR}/.."
readonly ARTIFACTS_DIR="${INCLUDES_DIR}/../artifacts"

##############
## Includes ##
##############
source "${INCLUDES_DIR}/bashlib.sh"
source "${INCLUDES_DIR}/functions.sh"
source "${INCLUDES_DIR}/vars.sh"
source "${INCLUDES_DIR}/vars.local.sh"

##########
## Main ##
##########

# Generate SSH keys.
lbs::artifact_gen_ssh

# Enable host machine SSH access with SSH public key.
lbs::set_admin_authorized_keys

# Download / Update Dansible.
lbs::dansible_artifact

# Initialize Dansible with SSH keys, admin credentials, and specified Ansible Content repo.

# Configue SSHd
lbs::sshd_config

# Start SSHd.
lbs::sshd_enable

# Run Dansible against localhost.
# lbs::run_dansible

# Stop SSHd.
lbs::sshd_disable