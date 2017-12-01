#!/bin/bash

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

# Linux version of OSX' pbcopy, pbpaste.
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
