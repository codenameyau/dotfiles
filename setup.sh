#!/bin/bash

# Update git-hooks directory.
chmod u+x git-hooks/*
cp -v git-hooks/post-commit--dotfiles .git/hooks/post-commit

# Copy and overwrite dotfiles.
cp -v shell/.bash_aliases ~/.bash_aliases
cp -v shell/.gitconfig ~/.gitconfig
cp -v shell/.gitignore_global ~/.gitignore_global

# Differentiate between .bashrc (linux) and .bash_profile (mac)
if [ -f ~/.bashrc ]; then
  cp -v shell/.bashrc ~/.bashrc
fi

if [ -f ~/.bash_profile ]; then
  cp -v shell/.bash_profile ~/.bash_profile
fi
