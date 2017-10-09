#!/bin/bash

# Make directories if not exist.
mkdir -p $HOME/Workspace

# Install Homebrew.
if [ ! -x "$(command -v brew)" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update

# Brew install default packages.
brew install coreutils cmake ack wget curl htop git python python3 ruby n

# Brew terminal plugins (requires .bash_profile).
brew install source-highlight bash-completion the_silver_searcher git-extras shellcheck gpg

# Brew install vim and override vi.
brew install vim --with-override-system-vi

# Brew GNU default commands.
brew install gnu-sed --with-default-names

# Set nodejs version.
sudo n 8

# Lastly run brew doctor and fix package dependencies.
brew doctor
brew prune

# Install useful python third-party tools.
sudo pip3 install tldr requests virtualenv

# Install common nodejs third-party tools.
sudo npm install -g http-server eslint webpack jest

# Install optional nodejs tools.
sudo npm install -g gulp mocha cost-of-modules artillery

# Download personal dotfiles from github.
if [ ! -f $HOME/.bash_extras ]; then
  wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_extras -P ~
fi

wget https://raw.githubusercontent.com/codenameyau/shiny-prompt/master/src/.bash_prompt -P ~
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_alias -P ~
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.bash_profile -P ~
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitconfig -P ~
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitignore_global -P ~
