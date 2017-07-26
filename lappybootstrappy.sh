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
TARGET_USER="$1"
ADMIN_PASS="$2"
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
source "${INCLUDES_DIR}/wrapper.sh"

##########
## Main ##
##########
wrapper::set_run_by_admin
wrapper::set_admin_user
wrapper::set_target_user
wrapper::run_main