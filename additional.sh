brew cask install iterm2
brew cask install atom
defaults write com.apple.dock static-only -bool TRUE; killall Dock
brew cask install alfred
brew cask install shiftit
brew install zsh
sudo -s 'echo /usr/local/bin/zsh >> /etc/shells' && chsh -s /usr/local/bin/zsh
brew cask install 1password
open ~/Documents/licenses/my.onepassword7-license-mac
atom ~/Documents/licenses/alfred.license
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
plugins=(git colored-man colorize pip python brew osx zsh-syntax-highlighting)
brew cask install docker
brew cask install google-chrome
brew cask install vagrant
brew install wget
brew install php@7.1 composer
brew cask install balenaetcher
brew cask install vscodium
brew cask install signal
npm install -g localtunnel