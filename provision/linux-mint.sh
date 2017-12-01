#!/bin/bash

# Add dotfiles.
wget_file .bash_extras https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_extras
wget_file .bash_prompt https://raw.githubusercontent.com/codenameyau/shiny-prompt/master/src/.bash_prompt
wget_file .bash_alias https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_alias
wget_file .bashrc https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bashrc
wget_file .gitconfig https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitconfig
wget_file .gitignore_global https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitignore_global

# Add Personal Package Archives (ppa)
sudo add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"
sudo add-apt-repository ppa:git-core/ppa
sudo apt-get update

# Install heroku.
curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -
sudo apt-get install heroku

# Install other third party packages.
sudo apt-get install -y xsel

# Make custom directories.
mkdir -p $HOME/Workspace
