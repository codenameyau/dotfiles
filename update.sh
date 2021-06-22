#!/bin/bash

# Copy and overwrite dotfiles.
cp -v shell/.bash_aliases ~/.bash_aliases
cp -v shell/.gitconfig ~/.gitconfig
cp -v shell/.gitignore_global ~/.gitignore_global

# Differentiate between .bashrc (linux) and .bash_profile (mac)
if [ -f ~/.bashrc ]; then
  cp -v shell/.bashrc ~/.bashrc
  cp -v shell/.bash_extras ~/.bash_extras
fi

if [ -f ~/.bash_profile ]; then
  cp -v shell/.bash_profile ~/.bash_profile
  cp -v shell/.bash_extras ~/.bash_extras
fi

if [ -f ~/.zshrc ]; then
  cp -v shell/.zshrc ~/.zshrc
  cp -v shell/.zshrc_extras ~/.zshrc_extras
fi
