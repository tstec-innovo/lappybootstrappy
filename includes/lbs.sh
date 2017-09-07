lbs::logo() {
  echo -n "${STYLE_MAGENTA}"
  cat <<"EOF"
  ┏━━━━━━━━━━━━━━┓
  ┃  LAPPY _/    ┃
  ┃  BOOTSTRAPPY ┃
  ┗━━━━━━━━━━━━━━┛
EOF
  echo "   ©$( date +%Y ) Neutron37"
  echo "${STYLE_RED}"

  cat <<"EOF"
  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
  ┃ WARNING:                                                                 ┃
  ┃ This script makes the assumption that SSH access to your laptop is used  ┃
  ┃ exclusivley for its own self-provisioning process. This script enables & ┃
  ┃ disables SSHd as needed. It also uses dseditgroup to manage sshd access, ┃
  ┃ so if you're also using dseditgroup for that purpose this script will    ┃
  ┃ very likely clobber your config.                                         ┃
  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
EOF
  echo "${STYLE_NORMAL}"
}

lbs::run_dansible() {
  # Test with adhoc command "hostname"
  lbs::docker_run "-a 'hostname'"
}

lbs::ssh_add_dansible_content_key() {
  if [ ! -z "${DANSIBLE_CONTENT_SSH_KEY}" ]; then
    KEY=$( bashlib::expand_path "${DANSIBLE_CONTENT_SSH_KEY}" )
    ssh-add $KEY
  fi
}

lbs::dansible_artifact() {
  if [ ! -d ${ARTIFACTS_DIR}/dansible ]; then
    mkdir -p ${ARTIFACTS_DIR}/dansible
  fi
  if [ ! -f ${ARTIFACTS_DIR}/dansible/README.md ]; then
    bashlib::msg_stdout "Loading D A N S I B L E artifact."
    lbs::ssh_add_dansible_content_key
    git clone "${DANSIBLE_URL}" "${ARTIFACTS_DIR}/dansible" --recursive
  else
    lbs::ssh_add_dansible_content_key
    cd "${ARTIFACTS_DIR}/dansible"
    echo -n "Updating D A N S I B L E artifact. "
    git pull
  fi
}

lbs::artifact_gen_ssh() {
  if [ ! -d "${ARTIFACTS_DIR}/ssh" ]; then
    mkdir -p "${ARTIFACTS_DIR}/ssh"
  fi
  if [ ! -f "${ARTIFACTS_DIR}/ssh/dansible_rsa_4096.key" ]; then
    echo "Generating ${ARTIFACTS_DIR}/ssh/dansible_rsa_4096.key."
    ssh-keygen -t rsa -b 4096 -N "" -f "${ARTIFACTS_DIR}/ssh/dansible_rsa_4096.key"
    chmod 500 "${ARTIFACTS_DIR}/ssh/dansible_rsa_4096.key"
    chmod 500 "${ARTIFACTS_DIR}/ssh/dansible_rsa_4096.key.pub"
  fi
}

lbs::ensure_file_admin_authorized_keys() {
  RESULT=$( bashlib::run_as_admin "mkdir ~/.ssh" 2> /dev/null )
  RESULT=$( bashlib::run_as_admin "touch ~/.ssh/authorized_keys" )
  RESULT=$( bashlib::run_as_admin "chmod 500 ~/.ssh/authorized_keys" )
}

lbs::set_admin_authorized_keys() {
  lbs::ensure_file_admin_authorized_keys
  ADMIN_PUBKEY_FILE="${ARTIFACTS_DIR}/ssh/dansible_rsa_4096.key.pub"
  ADMIN_PUBKEY=$( cat "${ADMIN_PUBKEY_FILE}" )
  RESULT=$( bashlib::run_as_admin "grep '${ADMIN_PUBKEY}' ~/.ssh/authorized_keys" )
  if [ ! "$?" -eq 0 ]; then

    ## Working around expect limitations with file copies.
    echo "Setting pubkey for ${ADMIN_USER}."
    RESULT=$( bashlib::run_as_admin "cp ~/.ssh/authorized_keys ~/.ssh/authorized_keys.${CMD_TIME}.backup" )
    RESULT=$( bashlib::run_as_admin "cp ~/.ssh/authorized_keys /tmp/ak_tmp" )
    RESULT=$( bashlib::run_as_sudo "chmod a+rw /tmp/ak_tmp" )
    echo "${ADMIN_PUBKEY}" >> /tmp/ak_tmp
    RESULT=$( bashlib::run_as_sudo "chmod a-rwx,u+rw /tmp/ak_tmp" )
    RESULT=$( bashlib::run_as_admin "mv -f /tmp/ak_tmp ~/.ssh/authorized_keys" )
  fi
}

lbs::sshd_config() {
  echo "Running dseditgroup -o create com.apple.access_ssh."
  RESULT=$( bashlib::run_as_sudo "dseditgroup -o create com.apple.access_ssh" )
  echo "Adding user ${ADMIN_USER} to com.apple.access_ssh."
  RESULT=$( bashlib::run_as_sudo "dseditgroup -o edit -a ${ADMIN_USER} -t user com.apple.access_ssh" )
}

lbs::sshd_enable() {
  SSH_STATUS=$( bashlib::run_as_sudo "/usr/sbin/systemsetup -getremotelogin")
  echo $SSH_STATUS | grep "Remote Login: Off" > /dev/null
  if [ "$?" -eq 0 ]; then
    echo "Starting sshd."
    RESULT=$( bashlib::run_as_sudo "/usr/sbin/systemsetup -setremotelogin on" )
  fi
}

lbs::sshd_disable() {
  # SSH always disabled afterwards as a precaution.
  echo "Stopping sshd."
  RESULT=$( bashlib::run_as_sudo "/usr/sbin/systemsetup -f -setremotelogin off" )
}