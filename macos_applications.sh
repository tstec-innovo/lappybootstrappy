# iterm2
brew cask install iterm2
  # Don’t display the annoying prompt when quitting iTerm
  defaults write com.googlecode.iterm2 PromptOnQuit -bool false
  # Install iterm2 zsh shell integration
  curl -q -L https://iterm2.com/shell_integration/zsh \
    -o ~/.iterm2_shell_integration.zsh
  # Install imgcat
  curl -s -L https://www.iterm2.com/utilities/imgcat \
    -o ~/.local/bin/imgcat
  chmod +x ~/.local/bin/imgcat
  # Install imgls
  curl -s -L https://www.iterm2.com/utilities/imgls \
    -o ~/.local/bin/imgls
  chmod +x ~/.local/bin/imgls
  # Install divider
  curl -s -L https://raw.githubusercontent.com/gnachman/iTerm2/master/tests/divider \
    -o ~/.local/bin/divider
  chmod +x ~/.local/bin/divider

# zsh
brew install zsh
  # Install OhMyZsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  # Install OhMyZsh plugins
  brew install zsh-autosuggestions
  brew install zsh-navigation-tools
  brew install zsh-syntax-highlighting
  brew install zsh-completions

  brew install tree
  # Fix permissions
  compaudit |  xargs chmod g-w,o-w
  # https://unix.stackexchange.com/questions/210930/completions-stopped-working-after-upgrading-zsh/210931#210931
  rm ~/.zcompdump*

# VSCode
brew cask install visual-studio-code
open /Applications/Visual\ Studio\ Code.app

# ShiftIt
brew cask install shiftit
xattr -r -d com.apple.quarantine /Applications/ShiftIt.app
open /Applications/ShiftIt.app

# 1Password
brew cask install 1password
open ~/Documents/licenses/my.onepassword7-license-mac

# Docker
brew cask install docker
open /Applications/Docker.app

# Vagrant
brew cask install vagrant

# VirtualBox
brew cask install virtualbox

# MAS - Mac App Store command line interface
brew install mas

# Install keybase
brew cask install keybase
open /Applications/Keybase.app

# Alfred
brew cask install alfred

# Install useful commands
brew install wget ripgrep loc watch most

# Install PHP stuff
brew install php@7.1 composer

# Install etcher
brew cask install balenaetcher

# Install signal
brew cask install signal

# Install localtunnel
npm install -g localtunnel

# Install spotify
brew cask install spotify

# Install Bitwarden
brew cask install bitwarden

# Install Brave
brew cask install brave-browser

# Install Slack
brew cask install slack

# Install Thunderbird
brew cask install thunderbird

# Install kubernetes cli and related tools
brew install kubectx
brew install kube-ps1
brew install kubernetes-helm
brew install kubernetes-krew
brew install jq
kubectl krew install oidc-login

# Install openstack cli
python3 -m pip install python-openstackclient

# Install inconsolata-for-powerline
brew cask install homebrew/cask-fonts/font-inconsolata-for-powerline

# Install tunnelblick VPN client
brew cask install tunnelblick

# Install GPG
brew install gnupg

# Install gitKraken
brew cask install gitkraken