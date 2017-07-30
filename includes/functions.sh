lbs::logo() {
  echo -n "${STYLE_MAGENTA}"
  cat <<"EOF"
  ┏━━━━━━━━━━━━━━┓
  ┃  LAPPY _/    ┃
  ┃  BOOTSTRAPPY ┃
  ┗━━━━━━━━━━━━━━┛
EOF
  echo "   ©`date +%Y` Neutron37"
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
  /usr/local/bin/docker build --squash -f ./Dockerfile .
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
  DOCKER_IMAGE="9696dbe7fe59"
  VAULT_PASSWORD_FILE="/ansible_content/artifacts/dansible_vault.password"
  HOSTS_FILE="/ansible_content/dockerhost"
  docker run -v "${ARTIFACTS_DIR}/ansible_content/artifacts:/ansible_content/artifacts" "${DOCKER_IMAGE}" dockerhost --vault-password-file="${VAULT_PASSWORD_FILE}" -i "${HOSTS_FILE}" "$@"
}

lbs::run_dansible() {
  # Test with adhoc command "hostname"
  lbs::docker_run "-a 'hostname'"
}

lbs::sshd_enable() {
  bashlib::run_as_sudo "ls" 2> /dev/null
}