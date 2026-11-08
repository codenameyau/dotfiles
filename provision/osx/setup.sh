#!/bin/bash
# Do these steps first:
# - Install iterm2 and configure preferences to remap option navigation under:
#   Profiles > Keys > Send Escape Sequence (ESC + B) for Option + LEFT. Don't send HEX it doesn't work.
#
# - Setup SSH keys in github
#   ssh-keygen -t ed25519
#
# Safe to re-run: steps that are already done are skipped.

dotfiles_url="https://raw.githubusercontent.com/codenameyau/dotfiles/master"

# Make directories if not exist.
mkdir -p "$HOME/Workspace"

#####################################################################
# PACKAGES
#####################################################################

# Install Homebrew.
if [ ! -x "$(command -v brew)" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Put brew on PATH. Apple Silicon installs to /opt/homebrew, which is not on PATH by
# default; Intel installs to /usr/local. Also persist it for future login shells.
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [ -x "$brew_bin" ]; then
    eval "$("$brew_bin" shellenv)"
    shellenv_line="eval \"\$($brew_bin shellenv)\""
    grep -qxF "$shellenv_line" ~/.zprofile 2>/dev/null || echo "$shellenv_line" >> ~/.zprofile
    break
  fi
done

brew update

# Install ohmyzsh. --unattended keeps the installer from starting a new zsh,
# which would pause this script until that shell exits.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Brew install default packages.
brew install coreutils cmake ack wget curl htop git python3 ruby n pipx

# Brew terminal plugins (requires .bash_profile).
brew install source-highlight bash-completion git-extras shellcheck gpg watchman jq

# Download config files to the home directory, replacing existing ones.
for file in .gitconfig .gitignore_global .zshrc .zshrc_extras .ohmyzshrc; do
  curl -fsSL -o "$HOME/$file" "$dotfiles_url/shell/$file" &
done
wait

# https://github.com/junegunn/fzf
brew install fzf
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc

# https://fig.io/
# brew install fig

# Brew install vim and override vi.
# brew install vim --with-override-system-vi

# Brew GNU default commands.
brew install gnu-sed

# Set nodejs version (LTS).
sudo n lts

# Lastly run brew doctor and fix package dependencies.
brew doctor

# Install useful python third-party tools. Homebrew's Python blocks global
# `pip install` (PEP 668), so CLI tools go through pipx. For libraries such as
# requests, use a per-project virtualenv: python3 -m venv .venv
pipx ensurepath
pipx install virtualenv

# Install common nodejs third-party tools.
sudo npm install -g http-server eslint webpack jest tldr

# Install kubernetes zsh-kubectl-prompt.
brew tap superbrothers/zsh-kubectl-prompt
brew install zsh-kubectl-prompt

# Install vim config: https://github.com/codenameyau/dotfiles/tree/master/vim
curl -fsSL -o "$HOME/.vimrc" "$dotfiles_url/vim/.vimrc"
mkdir -p ~/.vim/bundle
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
vim +PluginInstall +qall
