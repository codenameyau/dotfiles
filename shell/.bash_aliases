#!/bin/bash

# Sourcing alias.
if [ -f ~/.bashrc ]; then
  alias sp="source ~/.bashrc"
elif [ -f ~/.bash_profile ]; then
  alias sp="source ~/.bash_profile"
fi

# Git shortcuts
alias ga="git add -A"
alias gb="git branch --sort=committerdate | tail -20"
alias gc="git commit"
alias gs="git status"
alias gg="git checkout -"
alias gd="git diff HEAD~$1 HEAD"
alias gl="git log --no-merges"
alias gr="git reset"
alias gp="git push"

# Other git commands.
alias git-pull-all="find . -maxdepth 3 -name .git -type d | rev | cut -c 6- | rev | xargs -I {} git -C {} pull"
alias git-prune="git branch --merged | grep -v '\*' | xargs -n1 git branch -d && git fetch origin --prune"
alias git-hide="git update-index --skip-worktree"
alias git-hide-undo="git update-index --no-skip-worktree"
alias git-ignore="git update-index --assume-unchanged"
alias git-ignore-undo="git update-index --no-assume-unchanged"
alias git-ignore-list="git ls-files -v | grep ^h"
alias git-changelog='git log $(git tag | tail -1)..HEAD --no-merges --pretty="[%h] %s"'

# Utilities.
alias projects="ls -d -1 $PWD/*/*/"
alias find-quickly="find . -maxdepth 3 -not \( -path *node_modules* -o -path *bower* \) -name"

function kill-port() {
  lsof -P -i tcp:"$1" | grep 'LISTEN' | awk '{ print $2 }' | xargs -I % sh -c  'echo "Killed port: %"; kill %;'
}

# Print timestamps with string. ex. timestamps 4 "-CREATE-"
function timestamps() {
  if [ -z $1 ]; then
    echo "Usage: timestamp 4"
  else
    for ((i=0; i<$1; i++)); do echo "$(($(date +%s) + $i))"$2; done
  fi
}

# Usage: git-replace 'src/js' 'my_string' 'myString'
function git-replace() {
  echo "Updated files:"
  git ls-files | grep $1 | xargs -n1 grep $2 -l
  git ls-files | grep $1 | xargs -n1 grep $2 -l | xargs -n1 sed -i "s/$2/$3/g"
}

# Merges master -> staging -> edge 
function ggg() {
  git checkout master
  git pull origin master
  git checkout staging
  git pull origin staging
  git merge master
  git push origin staging
  git checkout edge
  git pull origin edge
  git merge staging
  git push origin edge
}

function tickets() {
  git log --oneline "$1"..."$2" | grep -o -E '(AG|DASH)-\d+' | sort --unique | awk '{print "https://jira.ocrolus.com/browse/" $0}'
}
