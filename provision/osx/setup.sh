#!/bin/bash
# Do these steps first:
# - Install iterm2 and configure preferences to remap option navigation under: 
#   Profiles > Keys > Send Escape Sequence (ESC + B) for Option + LEFT. Don't send HEX it doesn't work.
# 
# - Setup SSH keys in github
#   ssh-keygen

# Make directories if not exist.
mkdir -p "$HOME/Workspace"

#####################################################################
# PACKAGES
#####################################################################

# Install Homebrew.
if [ ! -x "$(command -v brew)" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew update

# Install ohmyzsh
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

# Brew install default packages.
brew install coreutils cmake ack wget curl htop git python3 ruby n

# Brew terminal plugins (requires .bash_profile).
brew install source-highlight bash-completion git-extras shellcheck gpg watchman jq

# Download files via wget to home directory for configs.
rm ~/.gitconfig && wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitconfig &
rm ~/.gitignore_global && wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitignore_global &
rm ~/.zshrc && wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.zshrc &
rm ~/.ohmyzshrc && wget -q -N -P "$HOME" https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.ohmyzshrc &

# https://github.com/junegunn/fzf
brew install fzf
$(brew --prefix)/opt/fzf/install

# https://fig.io/
# brew install fig

# Brew install vim and override vi.
# brew install vim --with-override-system-vi

# Brew GNU default commands.
brew install gnu-sed

# Set nodejs version (LTS).
sudo n 18

# Lastly run brew doctor and fix package dependencies.
brew doctor

# Install useful python third-party tools.
sudo pip3 install requests virtualenv

# Install common nodejs third-party tools.
sudo npm install -g http-server eslint webpack jest tldr

# Install kubernetes zsh-kubectl-prompt.
brew tap superbrothers/zsh-kubectl-prompt
brew install zsh-kubectl-prompt

# Install vim config: https://github.com/codenameyau/dotfiles/tree/master/vim
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/vim/.vimrc -P ~
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
