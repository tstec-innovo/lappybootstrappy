#######################
## LIBRARY FUNCTIONS ##
#######################

bashlib::lanip() {
  /sbin/ifconfig | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep -v 127.0.0.1 | awk '{ print $2 }' | cut -f2 -d: | head -n1
}

bashlib::timestamp() {
  date +%Y.%m.%d_%H.%M.%S
}

bashlib::run_as_sudo() {
  ${INCLUDES_DIR}/su.expect "${ADMIN_USER}" "${ADMIN_PASS}" "echo ${ADMIN_PASS} | sudo -S --prompt='' $@"
}

bashlib::run_as_admin() {
  ${INCLUDES_DIR}/su.expect "${ADMIN_USER}" "${ADMIN_PASS}" "$@"
}

bashlib::run_as_target() {
  ${INCLUDES_DIR}/su.expect "${ADMIN_USER}" "${ADMIN_PASS}" "echo ${ADMIN_PASS} | sudo -S --prompt='' su ${TARGET_USER} -lc '$@'"
}

# abrt: prints abort message and exits
# arg1: message
bashlib::exit_fail() {
  bashlib::msg_stderr "${STYLE_BOLD}${STYLE_RED}$@${STYLE_NORMAL}"
  exit 37;
}

# abrt: prints sussess message and exits
# arg1: message
bashlib::exit_success() {
  bashlib::msg_stdout "${STYLE_BOLD}${STYLE_GREEN}$@${STYLE_NORMAL}"
  exit 0;
}

# msg: prints a message to stdout
# arg1: message
bashlib::msg_stdout() {
  if [ ! -z "$@" ]; then
    echo "$@"
  fi
}

# vmsg: prints a message to stderr
# arg1: message
bashlib::msg_stderr() {
  if [ ! -z "$@" ]; then
    echo "$@" >&2
  fi
}