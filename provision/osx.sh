#!/bin/bash

# Install Homebrew.
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install various brew dev packages.
brew update
brew install git
brew install python
brew install python3
brew install ruby
brew install nvm

# Install useful python third-party tools.
pip3 install tldr

# Brew terminal plugins (requires .bash_profile).
brew install wget
brew install source-highlight
brew install bash-completion

# Download personal dotfiles from github.
