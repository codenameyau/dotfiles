#####################################################################
# DEFAULT SETTINGS
#####################################################################

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/$(whoami)/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder
source $ZSH/oh-my-zsh.sh

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"



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
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# Include expanded globstar.
setopt extended_glob

# Share history between all sessions.
setopt SHARE_HISTORY

# Increase history size.
HISTSIZE=999999999
SAVEHIST=$HISTSIZE

#####################################################################
# THIRD-PARTY PACKAGES
#####################################################################

# Less syntax highlighting.
# https://ole.michelsen.dk/blog/syntax-highlight-files-macos-terminal-less/
LESSPIPE=`which src-hilite-lesspipe.sh`
export LESSOPEN="| ${LESSPIPE} %s"
export LESS=' -R -X -F '

# Better cmd-r history with fzf.
# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


#####################################################################
# SHELL CONFIGURATION
#####################################################################

PROMPT_COMMAND='echo -en "\033]0; $("pwd") \a"'

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

# Tickets for PO sign off.
function tickets() {
  git log --oneline "$1"..."$2" | grep -o -E '(AG|DASH)-\d+' | sort --unique | awk '{print "https://jira.ocrolus.com/browse/" $0}'
}

# Source organization extras.
source ~/.zshrc_extras
