#!/usr/bin/env bash
# <<YAMLDOC
# namespace: /neutron37/lappybootstrappy
# description: "Ansible Content Project"
# copyright: "Neutron37"
# authors: "neutron37@hauskreativ.com"
# tags: bootstrap macbook laptop ansible docker devkit
# YAMLDOC

##################################################################
# START bashlib boilerplate.                                     #
# See https://github.com/neutron37/bashlib/blob/master/README.md #
##################################################################
trap 'echo "Aborting  due to errexit on line $LINENO. Exit code: $?" >&2' ERR
set -euo pipefail
BASHLIB_SOURCE="${BASH_SOURCE[0]}"
while [ -h "${BASHLIB_SOURCE}" ]; do
  # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P $( dirname ${BASHLIB_SOURCE} ) && pwd )
  BSOURCE=$( readlink "${BASHLIB_SOURCE}" );
  [[ $BASHLIB_SOURCE != /* ]] && SOURCE="${DIR}/${BASHLIB_SOURCE}"
done
BASHLIB_THIS_DIR=$( dirname ${BASHLIB_SOURCE} )
export BASHLIB_THIS_DIR=$( cd -P $BASHLIB_THIS_DIR && pwd )
export BASHLIB_DIR="${BASHLIB_THIS_DIR}/bashlib"
if [ ! -d "${BASHLIB_DIR}" ]; then
  echo "------------------------------------------------------------"
  echo "Installing neutron37 bashlib."
  cd "${BASHLIB_THIS_DIR}"
  git clone https://github.com/neutron37/bashlib.git
  echo "------------------------------------------------------------"
fi
# Be sure to customize $BASHLIB_PROJECT_DIR for your project.
export BASHLIB_PROJECT_DIR=$( cd -P $BASHLIB_THIS_DIR/.. && pwd )
source "${BASHLIB_DIR}/bashlib.sh"
##################################################################
# END bashlib boilerplate.                                       #
##################################################################

lbs::logo() {
  echo -n "${STYLE_MAGENTA}"
  cat <<"EOF"
  ┏━━━━━━━━━━━━━━┓
  ┃  LAPPY _/    ┃
  ┃  BOOTSTRAPPY ┃
  ┗━━━━━━━━━━━━━━┛
EOF
  echo "   ©$( date +%Y ) Neutron37"
  echo "${STYLE_NORMAL}"
}

lbs::help() {

  lbs::logo

  # Read always returns non-zero
  # Because of "set -e" we must prepend '!'
  # Quoting the sentinel, HELP, prevents expansion in the text block.
  ! read -d '' MSG_HELP <<"HELP"

usage: lapybootstrappy.sh [--help] <subcommand>

These are the valid subcommands:
  install: Install it!

These are the valid flags:
  --help          Display this help.
HELP
  bashlib::msg_stdout "${MSG_HELP}"
  bashlib::exit_success ""
}

##########
## Args ##
##########
if [ -z "$*" ]; then
  lbs::help
fi

COMMAND="$@"

##########
## Main ##
##########

if [ -z ${@+x} ]; then
  lbs::help
fi

trap '' ERR
make "$@"
exit "$?"
