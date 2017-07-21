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
    sudo su -l ${ACTIVE_USER} -c "mkdir -p ${ARTIFACTS_DIR}/ansible"
  fi
  sudo su -l ${ACTIVE_USER} -c "git clone git://github.com/ansible/ansible.git ${ARTIFACTS_DIR}/ansible --recursive"
}

lbs::docker_start() {
  # Test Started
  sudo su -l ${ACTIVE_USER} -c '/usr/local/bin/docker info >/dev/null 2>/dev/null'
  DOCKER_RETURN_CODE=$?
  if [ ! $DOCKER_RETURN_CODE -eq 0 ]; then
    echo -n "Starting Docker."
    # Start Docker
    sudo su -l ${ACTIVE_USER} -c 'open -a /Applications/Docker.app/Contents/MacOS/Docker'
  fi
  until [ $DOCKER_RETURN_CODE -eq 0 ]; do
    sudo su -l ${ACTIVE_USER} -c '/usr/local/bin/docker info >/dev/null 2>/dev/null'
    DOCKER_RETURN_CODE=$?
    echo -n "."
    sleep 1
  done
}

lbs::install_docker() {
  if [ ! -f /Applications/Docker.app/Contents/MacOS/Docker ]; then
    lbs::install_brew
    # Tap homebrew casks.
    /usr/local/bin/brew tap caskroom/cask;
    # Cask install Docker.
    /usr/local/bin/brew cask reinstall docker;
  fi
}

lbs::install_brew() {
  if [ ! -f /usr/local/bin/brew ]; then
    lbs::install_xcode;
    bashlib::msg_stdout "Installing homebrew."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

    bashlib::msg_stdout "Ensuring Xcode license."
    sudo xcodebuild -license
  fi
}

lbs::install_xcode() {
  if [ ! -f /usr/bin/xcodebuild ]; then
    bashlib::msg_stdout "Installing xcode."
    xcode-select --install
  fi
}