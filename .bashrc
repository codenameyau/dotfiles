# Custom terminal prompt
. ~/.bash_prompt

# Ignore history
HISTIGNORE='cd*:ls*:rm*'

# Virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh

# Useful aliases
alias source-profile='source ~/.bashrc'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
alias ports='netstat -tulanp'
alias busy="cat /dev/urandom | hexdump -C"
