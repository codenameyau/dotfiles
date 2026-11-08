#!/bin/bash
# More can be found here.
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos

#####################################################################
# Screenshots
#####################################################################

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Save screenshots in PNG format (other options: bmp, gif, jpg, pdf, tiff)
defaults write com.apple.screencapture type -string "png"


#####################################################################
# Sleep
#####################################################################

# Disable machine sleep while charging
sudo pmset -c sleep 0

# Never go into computer sleep mode
sudo systemsetup -setcomputersleep Off > /dev/null


#####################################################################
# Finder
#####################################################################

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


#####################################################################
# OSX CONFIG
#####################################################################

# Close System Settings (called System Preferences before macOS 13), so it
# doesn't overwrite these changes when it quits.
for app in "System Settings" "System Preferences"; do
  pgrep -xq "$app" && osascript -e "tell application \"$app\" to quit"
done

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Require password immediately after sleep or screen saver begins.
# (The old com.apple.screensaver askForPassword keys are ignored since macOS 10.13.)
# Prompts for your login password.
sysadminctl -screenLock immediate -password -

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

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


#####################################################################
# APPLY
#####################################################################

# Restart the affected apps so the changes take effect.
killall Dock Finder SystemUIServer 2>/dev/null
