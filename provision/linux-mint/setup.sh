#!/bin/bash

#####################################################################
# Package Installation
#####################################################################

# Core utils. software-properties-common provides add-apt-repository.
sudo apt install -y build-essential software-properties-common curl

# Install git and git-lfs (large file storage).
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update -y
sudo apt install -y git git-lfs
git lfs install

# Install snap. Linux Mint 20+ blocks snapd by default; remove the block first.
sudo rm -f /etc/apt/preferences.d/nosnap.pref
sudo apt update -y
sudo apt install -y snapd

# Install heroku.
curl -fsSL https://cli-assets.heroku.com/install-ubuntu.sh | sh

# Install other third party packages.
sudo apt install -y xsel terminator jq

# Install node.js (current LTS).
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Install npm packages.
sudo npm install -g tldr http-server

# Install brave: https://brave.com/linux/
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources https://brave-browser-apt-release.s3.brave.com/brave-browser.sources
sudo apt update -y
sudo apt install -y brave-browser

#####################################################################
# Enable trackpad gestures with fusuma.
#####################################################################
sudo gpasswd -a "$USER" input
sudo apt -y install libinput-tools xdotool
sudo gem install fusuma
mkdir -p ~/.config/fusuma
wget -N -P "$HOME/.config/fusuma" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.config/fusuma/config.yml
gnome-session-properties

#####################################################################
# Personal Setup
#####################################################################
mkdir -p "$HOME/Workspace"
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/shiny-prompt/master/src/.bash_prompt &
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_extras &
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_aliases &
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bashrc &
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitconfig &
wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitignore_global &
