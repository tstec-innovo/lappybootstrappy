#!/usr/bin/env bash
# <<YAMLDOC
# namespace: /neutron37/ansible_content
# description: "Ansible Content Project"
# copyright: "Neutron37"
# authors: "neutron37@protonmail.com"
# tags: bootstrap macbook laptop ansible docker devkit
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

lbs::ansible_artifact
lbs::ansible_content_artifact
lbs::install_docker
lbs::docker_start
lbs::docker_build
