#!/usr/bin/env bash
# <<YAMLDOC
# namespace: /neutron37/lappybootstrappy
# description: "Ansible Content Project"
# copyright: "Neutron37"
# authors: "neutron37@protonmail.com"
# tags: bootstrap macbook laptop ansible docker devkit
# YAMLDOC

######################
## Script arguments ##
######################
ADMIN_PASS="$1"
TARGET_USER="$2"
ADMIN_USER="$3"

set -u
set -o pipefail

###############
## Variables ##
###############
readonly ACTIVE_USER=$( whoami )
readonly HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly INCLUDES_DIR="${HOME_DIR}/includes"
readonly ARTIFACTS_DIR="${HOME_DIR}/artifacts"

##############
## Includes ##
##############
source "${INCLUDES_DIR}/bashlib.sh"
source "${INCLUDES_DIR}/vars.sh"
source "${HOME_DIR}/vars.local.sh"

source "${INCLUDES_DIR}/wrapper.sh"
source "${INCLUDES_DIR}/lbs.sh"

##########
## Main ##
##########
lbs::logo

# Gather user info including admin authentication credentials.
wrapper::set_run_by_admin
wrapper::set_admin_user
wrapper::set_admin_password
wrapper::set_target_user

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