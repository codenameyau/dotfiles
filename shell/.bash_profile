#!/bin/bash

# Colorful terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Ignore history
HISTIGNORE='cd*:ls*:rm*'

# https://github.com/codenameyau/shiny-prompt
if [ -f ~/.bash_prompt ]; then
  source ~/.bash_prompt
fi

if [ -f ~/.bash_aliases ]; then
  source ~/.bash_aliases
fi

if [ -f ~/.bash_extras ]; then
  source ~/.bash_extras
fi

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
