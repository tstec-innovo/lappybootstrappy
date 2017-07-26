#!/usr/bin/env bash

ACTIVE_USER=$( whoami )
TARGET_USER="$1"
ADMIN_PASS="$2"
ADMIN_USER="$3"

readonly SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ensure_target_user() {
  # Ensure target user is set.
  if [ $CURRENTLY_ADMIN ]; then
    if [ -z "${TARGET_USER}" ]; then
      echo "You must include argument for TARGET_USER when running as admin."
      exit 37;
    fi
  else
    if [ -z "${TARGET_USER}" ]; then
      TARGET_USER=$( whoami )
    fi
  fi
  echo "Target user: ${TARGET_USER}."
}

run_main() {
  if [ $CURRENTLY_ADMIN ]; then
    "${SCRIPT_DIR}/includes/main.sh" "${TARGET_USER}" "${ACTIVE_USER}"
  else
    echo "A user from the admin group is required to run portions of this script."
    echo -n "Please provide ${ADMIN_USER}'s "
    su -l "${ADMIN_USER}" -c "${SCRIPT_DIR}/includes/main.sh ${TARGET_USER} ${ACTIVE_USER}"
  fi
}

members() {
  dscl . -list /Users | while read user; do printf "$user ";
    dsmemberutil checkmembership -U "$user" -G "$*";
  done | grep "is a member" | cut -d " " -f 1;
};

ADMIN_USER=$( members admin | grep -v root | head -n1 )
CURRENTLY_ADMIN=$( members admin | grep $( whoami ) )

ensure_target_user;
run_main;