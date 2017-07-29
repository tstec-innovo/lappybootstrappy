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

wrapper::set_admin_password() {
  if [ -z "${ADMIN_PASS}" ]; then
    read -s -p "${ADMIN_USER} password: " ADMIN_PASS
    echo
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
  echo "target user detected: ${TARGET_USER}"
}

wrapper::run_main() {
  "${INCLUDES_DIR}/main.sh" $@
}