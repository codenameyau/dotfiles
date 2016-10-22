#!/bin/bash

# Make certain useful folders.
mkdir -p $HOME/Workspace

# Install Homebrew.
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Brew dev packages.
brew update
brew install git
brew install python
brew install python3
brew install ruby
brew install nvm

# Brew GNU default commands.
brew install coreutils
brew install gnu-sed --with-default-names

# Brew terminal plugins (requires .bash_profile).
brew install source-highlight
brew install bash-completion
brew install ack

# Install useful python third-party tools.
pip3 install tldr
pip3 install requests
pip3 install virtualenv

# Download personal dotfiles from github.
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.ackrc -P ~
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_alias -P ~
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_extras -P ~
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_profile -P ~
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitconfig -P ~
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitignore_global -P ~
