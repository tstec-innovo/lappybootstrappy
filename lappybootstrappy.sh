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

##############
## Includes ##
##############
source "${INCLUDES_DIR}/bashlib.sh"
source "${INCLUDES_DIR}/functions.sh"
source "${INCLUDES_DIR}/vars.sh"
source "${INCLUDES_DIR}/wrapper.sh"

##########
## Main ##
##########
lbs::logo

# Gather user info including admin authentication credentials.
wrapper::set_run_by_admin
wrapper::set_admin_user
wrapper::set_admin_password
wrapper::set_target_user
# Run main.
wrapper::run_main "${ADMIN_USER}" "${ADMIN_PASS}" "${TARGET_USER}"