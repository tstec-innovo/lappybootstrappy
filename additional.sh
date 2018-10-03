brew cask install iterm2
brew cask install atom
defaults write com.apple.dock static-only -bool TRUE; killall Dock
brew cask install alfred
brew cask install shiftit
brew install zsh
sudo -s 'echo /usr/local/bin/zsh >> /etc/shells' && chsh -s /usr/local/bin/zsh
