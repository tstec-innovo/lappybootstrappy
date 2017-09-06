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

lbs::ansible_artifact() {
  if [ ! -d ${ARTIFACTS_DIR}/ansible ]; then
    mkdir -p ${ARTIFACTS_DIR}/ansible
  fi
  if [ ! -f ${ARTIFACTS_DIR}/ansible/README.md ]; then
    bashlib::msg_stdout "Loading Ansible artifact."
    git clone git://github.com/ansible/ansible.git "${ARTIFACTS_DIR}/ansible" --recursive
    git reset --hard "${ANSIBLE_VERSION}"
  else
    cd "${ARTIFACTS_DIR}/ansible"
    ACTIVE_ANSIBLE_VERSION=$( git describe )
    if [ "${ACTIVE_ANSIBLE_VERSION}" != "${ANSIBLE_VERSION}" ]; then
      echo -n "Updating Ansible artifact. "
      git pull
      git reset --hard "${ANSIBLE_VERSION}"
    fi
  fi
}

lbs::ssh_add_ansible_content() {
  if [ ! -z "${ANSIBLE_CONTENT_SSH_KEY}" ]; then
    KEY=$( bashlib::expand_path "${ANSIBLE_CONTENT_SSH_KEY}" )
    ssh-add $KEY
  fi
}

lbs::ansible_content_artifact() {
  if [ ! -d ${ARTIFACTS_DIR}/ansible_content ]; then
    mkdir -p ${ARTIFACTS_DIR}/ansible_content
  fi
  if [ ! -f ${ARTIFACTS_DIR}/ansible_content/README.md ]; then
    bashlib::msg_stdout "Loading Ansible Content artifact."
    lbs::ssh_add_ansible_content
    git clone "${ANSIBLE_CONTENT_URL}" "${ARTIFACTS_DIR}/ansible_content" --recursive
  else
    lbs::ssh_add_ansible_content
    cd "${ARTIFACTS_DIR}/ansible_content"
    echo -n "Updating Ansible Content artifact. "
    git pull
  fi
}

lbs::docker_build() {
  echo "${DOCKERHOST}" > "${ARTIFACTS_DIR}/ansible_hosts"
  cd "${HOME_DIR}"
  /usr/local/bin/docker build --iidfile="${ARTIFACTS_DIR}/dansible.iid" --squash -f ./Dockerfile .
}

lbs::docker_start() {
  # Test Started
  bashlib::run_as_target "/usr/local/bin/docker info" &> /dev/null
  DOCKER_RETURN_CODE=$?

  if [ ! $DOCKER_RETURN_CODE -eq 0 ]; then
    # Start Docker
    echo -n "Starting Docker."
    bashlib::run_as_sudo "open -a /Applications/Docker.app/Contents/MacOS/Docker" &> /dev/null
  fi

  until [ $DOCKER_RETURN_CODE -eq 0 ]; do
    bashlib::run_as_target "/usr/local/bin/docker info" &> /dev/null
    DOCKER_RETURN_CODE=$?
    echo -n "."
    sleep 1
  done
  echo ""
}

lbs::install_docker() {
  if [ ! -f /Applications/Docker.app/Contents/MacOS/Docker ]; then
    lbs::install_brew
    # Tap homebrew casks.
    bashlib::run_as_target /usr/local/bin/brew tap caskroom/cask;
    # Cask install Docker.
    bashlib::run_as_target /usr/local/bin/brew cask reinstall docker;
  fi
}

lbs::install_ansible() {
  if [ ! -f /usr/local/bin/ansible ]; then
    lbs::install_brew
    # Brew install ansible.
    bashlib::run_as_target /usr/local/bin/brew install ansible;
  fi
}

lbs::install_brew() {
  if [ ! -f /usr/local/bin/brew ]; then
    lbs::install_xcode;
    bashlib::msg_stdout "Installing homebrew."
    bashlib::run_as_target /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    bashlib::msg_stdout "Ensuring Xcode license."
    bashlib::run_as_sudo xcodebuild -license
  fi
}

lbs::install_xcode() {
  if [ ! -f /usr/bin/xcodebuild ]; then
    bashlib::msg_stdout "Installing xcode."
    bashlib::run_as_target xcode-select --install
  fi
}

lbs::run_ansible_content_init() {
  "${ARTIFACTS_DIR}/ansible_content/init.sh" $@
}

lbs::docker_run() {
  VAULT_PASSWORD_FILE="/ansible_content/artifacts/dansible_vault.password"
  HOSTS_FILE="/ansible_content/dockerhost"
  DOCKER_IID=$( cat "${ARTIFACTS_DIR}/dansible.iid" )
  echo "Running docker image with IID: ${DOCKER_IID}"
  docker run -v "${ARTIFACTS_DIR}/ansible_content/artifacts:/ansible_content/artifacts" "${DOCKER_IID}" dockerhost --user="${ADMIN_USER}" --become --vault-password-file="${VAULT_PASSWORD_FILE}" --extra-vars "ansible_become_pass=${ADMIN_PASS}" -i "${HOSTS_FILE}" "$@"
  #docker run --add-host dockerhost:"${DOCKERHOST}" -v "${ARTIFACTS_DIR}/ansible_content/artifacts:/ansible_content/artifacts" "${DOCKER_IID}" dockerhost --user="${ADMIN_USER}" --become --vault-password-file="${VAULT_PASSWORD_FILE}" -i "${HOSTS_FILE}" "$@"
}

lbs::run_dansible() {
  # Test with adhoc command "hostname"
  lbs::docker_run "-a 'hostname'"
}

lbs::sshd_config() {
  echo "Running dseditgroup -o create com.apple.access_ssh."
  RESULT=$( bashlib::run_as_sudo "dseditgroup -o create com.apple.access_ssh" )
  echo "Adding user ${ADMIN_USER} to com.apple.access_ssh."
  RESULT=$( bashlib::run_as_sudo "dseditgroup -o edit -a ${ADMIN_USER} -t user com.apple.access_ssh" )
}

lbs::ensure_file_admin_authorized_keys() {
  RESULT=$( bashlib::run_as_admin "mkdir ~/.ssh" 2> /dev/null )
  RESULT=$( bashlib::run_as_admin "touch ~/.ssh/authorized_keys" )
  RESULT=$( bashlib::run_as_admin "chmod 500 ~/.ssh/authorized_keys" )
}

lbs::set_admin_authorized_keys() {
  lbs::ensure_file_admin_authorized_keys
  ADMIN_PUBKEY_FILE="${ARTIFACTS_DIR}/ansible_content/artifacts/ssh/dansible_rsa_4096.key.pub"
  ADMIN_PUBKEY=$( cat "${ADMIN_PUBKEY_FILE}" )
  RESULT=$( bashlib::run_as_admin "grep '${ADMIN_PUBKEY}' ~/.ssh/authorized_keys" )
  if [ ! "$?" -eq 0 ]; then

    ## Stupid effing expect. Couln't get anything like this to work.
    # RESULT=$( bashlib::run_as_admin "cat ${ADMIN_PUBKEY_FILE} >> ~/.ssh/authorized_keys" )
    # RESULT=$( bashlib::run_as_admin "bash -c 'cat ${ADMIN_PUBKEY_FILE} >> ~/.ssh/authorized_keys'" )

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
  echo
  echo '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
  echo '!! After running, this script disables local SSH as a precaution . !!'
  echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  echo
  echo "Stopping sshd."
  RESULT=$( bashlib::run_as_sudo "/usr/sbin/systemsetup -f -setremotelogin off" )
  echo "${RESULT}"
}