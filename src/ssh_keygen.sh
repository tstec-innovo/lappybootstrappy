#!/bin/bash

##################################################################
##################################################################
# START bashlib include boilerplate.                             #
# See https://github.com/neutron37/bashlib/blob/master/README.md #
##################################################################
BASHLIB_SOURCE="${BASH_SOURCE[0]}"
while [ -h "${BASHLIB_SOURCE}" ]; do
  # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P $( dirname ${BASHLIB_SOURCE} ) && pwd )
  BSOURCE=$( readlink "${BASHLIB_SOURCE}" );
  [[ $BASHLIB_SOURCE != /* ]] && SOURCE="${DIR}/${BASHLIB_SOURCE}"
done
BASHLIB_THIS_DIR=$( dirname ${BASHLIB_SOURCE} )
export BASHLIB_THIS_DIR=$( cd -P $BASHLIB_THIS_DIR && pwd )
export BASHLIB_DIR=$( cd -P "${BASHLIB_THIS_DIR}/bashlib" && pwd )
source "${BASHLIB_DIR}/bashlib.sh"
##################################################################
# END bashlib include boilerplate.                               #
##################################################################

# Make brew available if it's not installed already.
bashlib::print_cmd   '[ -d $HOME/.ssh ] || mkdir -p "${HOME}/.ssh"'
                      [ -d $HOME/.ssh ] || mkdir -p "${HOME}/.ssh"
bashlib::print_cmd   '[ -f $HOME/.ssh/id_rsa ] || ssh-keygen -b4096 -f"${HOME}/.ssh/id_rsa"'
                      [ -f $HOME/.ssh/id_rsa ] || ssh-keygen -b4096 -f"${HOME}/.ssh/id_rsa"
bashlib::print_cmd   'cat "${HOME}/.ssh/id_rsa.pub"'
bashlib::msg_stdout   "$STYLE_MAGENTA********* Add this key to your git account! ******************$STYLE_GREEN $STYLE_BOLD"
                      cat "${HOME}/.ssh/id_rsa.pub"
bashlib::msg_stdout   "$STYLE_NORMAL$STYLE_MAGENTA**************************************************************"
bashlib::msg_stdout  "$STYLE_NORMAL------------------------------------------------------------"
