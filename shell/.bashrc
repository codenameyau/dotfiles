#!/bin/bash

# Source custom bash settings.
source ~/.bash_prompt
source ~/.bash_envs

# Linux version of OSX' pbcopy, pbpaste.
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'

# Ignore history
HISTIGNORE='cd*:ls*:rm*'

# Virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh
