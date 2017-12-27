#!/bin/bash

#####################################################################
# Personal Setup
#####################################################################

mkdir -p $HOME/Workspace
wget -P $HOME https://raw.githubusercontent.com/codenameyau/shiny-prompt/master/src/.bash_prompt
wget -P $HOME https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_extras
wget -P $HOME https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_aliases
wget -P $HOME https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bashrc
wget -P $HOME https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitconfig
wget -P $HOME https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitignore_global

#####################################################################
# Package Installation
#####################################################################

# Core utils.
sudo apt-get install -y build-essential

# Install git and git-lfs (large file storage).
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update -y
sudo apt-get install -y git
sudo apt-get install -y software-properties-common
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | os=ubuntu dist=trusty sudo -E bash
sudo apt-get install git-lfs
git lfs install

# Install heroku.
sudo add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
sudo apt-get update -y
curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -
sudo apt-get install -y heroku

# Install other third party packages.
sudo apt-get install -y xsel terminator

# Install node.js
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install npm packages.
sudo npm install -g tldr http-server

# TODO: Enable trackpad gestures.
