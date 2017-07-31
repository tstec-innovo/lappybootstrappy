#!/usr/bin/env bash

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
readonly TESTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly ACTIVE_USER=$( whoami )
readonly HOME_DIR="${TESTS_DIR}/../"
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
bashlib::run_as_sudo 'ls --fuck /'
if [ ! "$?" -eq 0 ]; then
  echo "bashlib::run_as_sudo command failed: $SU_CMD"
fi
bashlib::run_as_sudo 'ls -1 /'
