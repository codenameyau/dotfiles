#!/bin/bash

# TODO: Fix this outputs are being inversely displayed.
print_update() {
  echo $1 $2
  echo $(cmp "$1" "$2")
  if [ $(cmp --silent $1 $2) ]; then
    echo "[+] Copied file: $1 to $2"
  else
    echo "[-] Failed to copy file: $1 to $2"
  fi
}

# Update git directory.
chmod u+x git/*
cp git/post-commit-dotfiles .git/hooks/post-commit

# Copy and overwrite dotfiles.
cp shell/.bash_aliases ~/.bash_aliases
cp shell/.gitconfig ~/.gitconfig
cp shell/.gitignore_global ~/.gitignore_global

# Log outputs.
print_update "shell/.bash_aliases" "~/.bash_aliases"
print_update "shell/.gitconfig" "~/.gitconfig"
print_update "shell/.gitignore_global" "~/.gitignore_global"

# Differentiate between .bashrc (linux) and .bash_profile (mac)
if [ -f ~/.bashrc ]; then
  cp shell/.bashrc ~/.bashrc
  print_update "shell/.bashrc" "~/.bashrc"
fi

if [ -f ~/.bash_profile ]; then
  cp shell/.bash_profile ~/.bash_profile
  print_update "shell/.bash_profile" "~/.bash_profile"
fi
