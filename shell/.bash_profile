#!/bin/bash

# Colorful terminal
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# https://github.com/codenameyau/shiny-prompt
source ~/.bash_prompt
source ~/.bash_alias
source ~/.bash_extras

# Ignore history
HISTIGNORE='cd*:ls*:rm*'

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
