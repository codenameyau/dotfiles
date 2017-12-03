#!/bin/bash

# Core utils.
sudo apt-get update
sudo apt-get install -y build-essential

# Add Personal Package Archives (ppa)
sudo add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update

# Install heroku and signature key.
curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -
sudo apt-get install -y heroku

# Install git.
sudo apt-get install -y git

# Install node.js
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install other third party packages.
sudo apt-get install -y xsel terminator

# Enable trackpad gestures.

# Make custom directories.
mkdir -p $HOME/Workspace

# Add dotfiles.
wget .bash_extras https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_extras
wget .bash_prompt https://raw.githubusercontent.com/codenameyau/shiny-prompt/master/src/.bash_prompt
wget .bash_aliases https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_aliases
wget .bashrc https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bashrc
wget .gitconfig https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitconfig
wget .gitignore_global https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitignore_global
