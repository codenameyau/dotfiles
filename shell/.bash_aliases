#!/bin/bash

# Sourcing alias.
if [ -f ~/.bashrc ]; then
  alias sp="source ~/.bashrc"
elif [ -f ~/.bash_profile ]; then
  alias sp="source ~/.bash_profile"
fi

# Git command aliases
alias ga="git add -A"
alias gc="git commit"
alias gs="git status"
alias gg="git checkout -"
alias gd="git diff HEAD~$1 HEAD"
alias git-pull-all="find . -maxdepth 3 -name .git -type d | rev | cut -c 6- | rev | xargs -I {} git -C {} pull"
alias git-prune="git branch --merged | grep -v '\*' | xargs -n1 git branch -d && git fetch origin --prune"
alias git-hide="git update-index --skip-worktree"
alias git-hide-undo="git update-index --no-skip-worktree"
alias git-ignore="git update-index --assume-unchanged"
alias git-ignore-undo="git update-index --no-assume-unchanged"
alias git-ignore-list="git ls-files -v | grep ^h"

# Utilities.
alias projects="ls -d -1 $PWD/*/*/"
alias find-quickly="find . -maxdepth 3 -not \( -path *node_modules* -o -path *bower* \) -name"

# Print timestamps with string. ex. timestamps 4 "-CREATE-"
function timestamps() {
  if [ -z $1 ]; then
    echo "Usage: timestamp 4"
  else
    for ((i=0; i<$1; i++)); do echo "$(($(date +%s) + $i))"$2; done
  fi
}

# Usuage: git-replace 'src/js' 'my_string' 'myString'
function git-replace() {
  echo "Updated files:"
  git ls-files | grep $1 | xargs -n1 grep $2 -l
  git ls-files | grep $1 | xargs -n1 grep $2 -l | xargs -n1 sed -i "s/$2/$3/g"
}
