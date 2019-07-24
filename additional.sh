# MacOS configuration
defaults write com.apple.dock static-only -bool TRUE; killall Dock

# iterm2 + shell integration
brew cask install iterm2
curl -L https://iterm2.com/shell_integration/zsh \
  -o ~/.iterm2_shell_integration.zsh

# atom
brew cask install atom
open /Applications/Atom.app

# VSCode
brew cask install visual-studio-code
open /Applications/Visual\ Studio\ Code.app

# Alfred
brew cask install alfred
atom ~/Documents/licenses/alfred.license
open /Applications/Alfred\ 4.app

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

# Chrome
brew cask install google-chrome
open /Applications/Google\ Chrome.app

# Vagrant
brew cask install vagrant

# VirtualBox
brew cask install virtualbox

# MAS - Mac App Store command line interface
brew install mas
# Install Things 3
mas install 904280696
# Install Marked 2
mas install 890031187

# Install keybase
brew cask install keybase
open /Applications/Keybase.app

# Sync Desktop
cd /tmp
git clone keybase://private/neutron37/Desktop
mv Desktop/.git ~/Desktop
rsync -av Desktop/ ~/Desktop
rm -rf /tmp/Desktop

# Sync Documents
git clone keybase://private/neutron37/Documents
mv Documents/.git ~/Documents
rsync -av Documents/ ~/Documents
rm -rf /tmp/Documents

# Sync home
git clone keybase://private/neutron37/home
mv home/.git $HOME/
rsync home/ $HOME
rm -rf /tmp/home

# Install useful commands
brew install wget ripgrep loc

# Install PHP stuff
brew install php@7.1 composer

# Install etcher
brew cask install balenaetcher

# Install signal
brew cask install signal

# Install localtunnel
npm install -g localtunnel

# Install OhMyZsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
