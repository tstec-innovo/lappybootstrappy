#!/usr/bin/env bash
set -x

# Set hostname
sudo scutil --set HostName MBP2019.satori.us
sudo scutil --set LocalHostName MBP2019.lan
sudo scutil --set ComputerName MBP2019
dscacheutil -flushcache

# Set sleep options for battery
sudo pmset -b displaysleep 1 disksleep 1 sleep 5

# Set sleep options for charger (wall power)
sudo pmset -c displaysleep 5 disksleep 5 sleep 5

# Disable the sudden motion sensor as it’s not useful for SSDs
sudo pmset -a sms 0

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Turn on dark mode
osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'

# Remove all persistent Applications from dock
defaults write com.apple.dock static-only -bool TRUE

# Menu bar: show remaining battery time (on pre-10.8); hide percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"
defaults write com.apple.menuextra.battery ShowTime -string "YES"

# Set highlight color to pink
defaults write NSGlobalDomain AppleHighlightColor -string '1.000000 0.749020 0.823529'

# Set accent color to pink
defaults write NSGlobalDomain AppleAccentColor -int '6'

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Ensure the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "$HOME/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Enable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool true

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool true

# Set dock tile size
defaults write com.apple.dock tilesize -int 128

# set dock tile large size
defaults write com.apple.dock largesize -int 85

# autohide dock
defaults write com.apple.dock autohide -bool true

# remove delay
defaults write com.apple.dock autohide-delay -float 0

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Allow text selection in the Quick Look window
defaults write com.apple.finder QLEnableTextSelection -bool true

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Enable natural scrolling
defaults write -g com.apple.swipescrolldirection -bool true

# Disable useless dashboard
defaults write com.apple.dashboard mcx-disabled -boolean YES

# Restart the dock
killall Dock
