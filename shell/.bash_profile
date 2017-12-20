#!/bin/bash

#####################################################################
# HISTORY
#####################################################################

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Ignore history
HISTIGNORE='cd*:rm*'

# See HISTSIZE and HISTFILESIZE in docs.
HISTSIZE=100
HISTFILESIZE=200

# Clear history when exiting a session.
# unset HISTFILE

#####################################################################
# TERMINAL PROFILE
#####################################################################

# Colorful terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Brew: source-highlight
# https://ole.michelsen.dk/blog/syntax-highlight-files-macos-terminal-less.html
LESSPIPE=`which src-hilite-lesspipe.sh`
export LESSOPEN="| ${LESSPIPE} %s"
export LESS=' -R -X -F '

# Brew: bash-completion
# https://github.com/bobthecow/git-flow-completion/wiki/Install-Bash-git-completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi


#####################################################################
# ADDITIONAL BASH CONFIG
#####################################################################


# https://github.com/codenameyau/shiny-prompt
if [ -f ~/.bash_prompt ]; then
  source ~/.bash_prompt
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

# Put custom commands in this file.
if [ -f ~/.bash_extras ]; then
  source ~/.bash_extras
fi

