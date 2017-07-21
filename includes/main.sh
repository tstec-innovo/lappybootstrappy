#!/usr/bin/env bash
# <<YAMLDOC
# namespace: /neutron37/lappybootstrappy
# description: "Macbook Initialization"
# copyright: "Neutron37"
# authors: "neutron37@protonmail.com"
# tags: bootstrap macbook laptop ansible docker devkit
# YAMLDOC

set -u
set -o pipefail

###############
## Constants ##
###############
# Reference: https://stackoverflow.com/a/246128
readonly INCLUDES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly HOME_DIR="${INCLUDES_DIR}/.."
readonly ARTIFACTS_DIR="${INCLUDES_DIR}/../artifacts"
readonly ACTIVE_USER=$1

##############
## Includes ##
##############
source "${INCLUDES_DIR}/bashlib.sh"
source "${INCLUDES_DIR}/vars.sh"
source "${INCLUDES_DIR}/functions.sh"

##########
## Main ##
##########

lbs::logo
lbs::install_docker
lbs::docker_start
lbs::ansible_artifact