#!/bin/bash

# Do these steps first:
# - Install iterm2 and configure preferences to remap option navigation under: 
#   Profiles > Keys > Send Escape Sequence (ESC + B) for Option + LEFT. Don't send HEX it doesn't work.
# 
# - Setup SSH keys in github
#   ssh-keygen


# Make directories if not exist.
mkdir -p "$HOME/Workspace"

#####################################################################
# PACKAGES
#####################################################################

# Install Homebrew.
if [ ! -x "$(command -v brew)" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update

# Brew install default packages.
brew install coreutils cmake ack wget curl htop git python3 ruby n

# Brew terminal plugins (requires .bash_profile).
brew install source-highlight bash-completion git-extras shellcheck gpg watchman jq

# Brew install vim and override vi.
brew install vim --with-override-system-vi

# Brew GNU default commands.
brew install gnu-sed

# Set nodejs version.
sudo n 12

# Lastly run brew doctor and fix package dependencies.
brew doctor
brew prune

# Install useful python third-party tools.
sudo pip3 install requests virtualenv

# Install common nodejs third-party tools.
sudo npm install -g http-server eslint webpack jest tldr


#####################################################################
# CUSTOM CONFIG
#####################################################################

# Download files via wget to home directory.
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/shiny-prompt/master/src/.bash_prompt &
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_extras &
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_aliases &
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bashrc &
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_profile &
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitconfig &
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitignore_global &

# Add vscode to path.
cat << EOF >> ~/.bash_extras
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF

# Install vim config.
# https://github.com/codenameyau/dotfiles/tree/master/vim
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/vim/.vimrc -P ~
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim


#####################################################################
# OSX CONFIG
# https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#####################################################################

# Close any open System Preferences panes, to prevent overriding.
osascript -e 'tell application "System Preferences" to quit'

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable machine sleep while charging
# sudo pmset -c sleep 0

# Never go into computer sleep mode
# sudo systemsetup -setcomputersleep Off > /dev/null

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false
