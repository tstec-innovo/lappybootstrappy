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
  else
    echo -n "Updating Ansible artifact. "
    cd "${ARTIFACTS_DIR}/ansible"
    git pull
  fi
}

lbs::docker_build() {
  echo "${DOCKERHOST}" > "${ARTIFACTS_DIR}/ansible_hosts"
  cd "${HOME_DIR}"
  /usr/local/bin/docker build -f ./Dockerfile .
}

lbs::docker_start() {
  # Test Started
  bashlib::run_as_target "/usr/local/bin/docker info"
  DOCKER_RETURN_CODE=$?

  if [ ! $DOCKER_RETURN_CODE -eq 0 ]; then
    # Start Docker
    echo -n "Starting Docker."
    bashlib::run_as_sudo "open -a /Applications/Docker.app/Contents/MacOS/Docker"
  fi

  until [ $DOCKER_RETURN_CODE -eq 0 ]; do
    bashlib::run_as_target "/usr/local/bin/docker info"
    DOCKER_RETURN_CODE=$?
    echo -n "."
    sleep 1
  done
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