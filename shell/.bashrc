#!/bin/bash

# Ignore history
HISTIGNORE='cd*:ls*:rm*'

# https://github.com/codenameyau/shiny-prompt
source ~/.bash_prompt
source ~/.bash_alias
source ~/.bash_extras

# Linux version of OSX' pbcopy, pbpaste.
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

