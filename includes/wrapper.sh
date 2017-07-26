wrapper::members() {
  dscl . -list /Users | while read user; do printf "$user ";
    dsmemberutil checkmembership -U "$user" -G "$*";
  done | grep "is a member" | cut -d " " -f 1;
};

wrapper::set_run_by_admin() {
  RUN_BY_ADMIN=$( wrapper::members admin | grep $( whoami ) )
}

wrapper::set_admin_user() {
  if [ -z "${ADMIN_USER}" ]; then
    ADMIN_USER=$( wrapper::members admin | grep -v root | head -n1 )
  fi
}

# Ensure target user is set.
wrapper::set_target_user() {
  if [ "${RUN_BY_ADMIN}" ]; then
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

wrapper::run_main() {
  if [ "${RUN_BY_ADMIN}" ]; then
    "${INCLUDES_DIR}/main.sh" "${TARGET_USER}" "${ACTIVE_USER}"
  else
    echo "A user from the admin group is required to run portions of this script."
    echo -n "Please provide authentication for the user, ${ADMIN_USER}. "
    su -l "${ADMIN_USER}" -c "${INCLUDES_DIR}/main.sh ${TARGET_USER} ${ACTIVE_USER}"
  fi
}

