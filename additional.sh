# MacOS configuration
defaults write com.apple.dock static-only -bool TRUE; killall Dock

# iterm2
brew cask install iterm2

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


brew install wget ripgrep loc
brew install php@7.1 composer
brew cask install balenaetcher

brew cask install signal
npm install -g localtunnel
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
