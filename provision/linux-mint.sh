#!/bin/bash

#####################################################################
# Package Installation
#####################################################################

# Core utils.
sudo apt install -y build-essential

# Install git and git-lfs (large file storage).
sudo add-apt-repository ppa:git-core/ppa
sudo apt update -y
sudo apt install -y git
sudo apt install -y software-properties-common
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | os=linuxmint dist=sonya sudo -E bash
sudo apt install git-lfs
git lfs install

# Install snap.
sudo apt install snapd

# Install heroku.
sudo add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
sudo apt update -y
curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -
sudo apt install -y heroku

# Install other third party packages.
sudo apt install -y xsel terminator jq

# Install node.js
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs

# Install npm packages.
sudo npm install -g tldr http-server

# Install brave.
sudo apt install apt-transport-https curl
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
source /etc/os-release
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ $UBUNTU_CODENAME main" | sudo tee /etc/apt/sources.list.d/brave-browser-release-${UBUNTU_CODENAME}.list
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
wget -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/shiny-prompt/master/src/.bash_prompt
wget -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_extras
wget -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_aliases
wget -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bashrc
wget -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitconfig
wget -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitignore_global
