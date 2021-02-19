#####################################################################
# ZSH CONFIGURATION
#####################################################################

# Enable glob patterns: (case insesitive, matching)
setopt EXTENDED_GLOB

# Wait before running rm *.
setopt RM_STAR_WAIT

# Enables changing dir without cd.
setopt AUTO_CD

# Ignore duplicate entries in history.
setopt HIST_IGNORE_ALL_DUPS


#####################################################################
# SHELL CONFIGURATION
#####################################################################

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
