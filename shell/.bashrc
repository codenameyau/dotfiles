#!/bin/bash

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

#####################################################################
# PATH EXTENSION
#####################################################################
export PATH=$PATH:/opt/cabal/bin:/snap/bin

#####################################################################
# HISTORY
#####################################################################

# Don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# Ignore history
HISTIGNORE='cd*:rm*:ls*'

# Append to the history file, don't overwrite it
shopt -s histappend

# See HISTSIZE and HISTFILESIZE in docs.
HISTSIZE=9999
HISTFILESIZE=9999

# Clear history when exiting a session.
# unset HISTFILE

# Change editor to vim
export VISUAL=vim
export EDITOR=vim

#####################################################################
# TERMINAL PROFILE
#####################################################################

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm|xterm-color|*-256color) color_prompt=yes;;
esac

# Uncomment for a colored prompt, if the terminal has the capability;
# Turned off by default to not distract the user:
# The focus in a terminal window should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  if [[ ${EUID} == 0 ]] ; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
  else
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w \$\[\033[00m\] '
  fi
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h \w \$ '
fi

unset color_prompt force_color_prompt

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto --group-directories-first -h'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
  alias grep='grep --color=auto -E'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Enable programmable completion features
# Usually already enabled in: '/etc/bash.bashrc' and '/etc/profile'
# Add more autocompletions in: '/etc/bash_completion.d'
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#####################################################################
# UNIVERSAL ALIASES
#####################################################################

# Shortcuts. Use "cd -" for longer directories.
alias ..="cd .."
alias ...="cd ../.."

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands. Use like so:
# sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Linux version of OSX pbcopy and pbpaste.
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'


#####################################################################
# ADDITIONAL BASH CONFIG
#####################################################################

# # https://github.com/codenameyau/shiny-prompt
# if [ -f ~/.bash_prompt ]; then
#   source ~/.bash_prompt
# fi

# # Alias definitions.
# if [ -f ~/.bash_aliases ]; then
#   source ~/.bash_aliases
# fi

# # Put custom commands in this file.
# if [ -f ~/.bash_extras ]; then
#   source ~/.bash_extras
# fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
