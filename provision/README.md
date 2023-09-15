# provision

## App Installation
- Install Licecap: https://github.com/justinfrankel/licecap
- Install Postman: https://www.getpostman.com/
- Install GitKraken: https://www.gitkraken.com/
- Install VSCode: https://code.visualstudio.com/
- Install 1Password: https://1password.com/

## Dev Setup
- Setup GitHub SSH key: https://help.github.com/articles/connecting-to-github-with-ssh/
- Setup GitHub GPG Key: https://help.github.com/articles/signing-commits-with-gpg/
- Syntax highlight with less: https://ole.michelsen.dk/blog/syntax-highlight-files-macos-terminal-less.html
- Update dotfiles and git hooks: https://github.com/codenameyau/dotfiles

## Mac Setup

### Update Default Mac Settings
- Hide Dock: `System Preferences > Dock`
- Switch off sorting desktop by frequency: http://www.macobserver.com/tmo/answers/prevent_lions_spaces_from_automatically_changing_order

### Keyboard Shortcuts
- Remap terminal keyboard shortcuts: https://stackoverflow.com/a/81299
- Remap `cmd+q` to show desktop in `System Preferences > Keyboard > Shortcuts > Mission Control > Show Desktop`.

![Show Desktop](https://user-images.githubusercontent.com/3826772/268161284-ec16e492-bbf7-4783-8ea4-58f7baa5990f.png)

### Dev Environment Setup

Run automated script: https://github.com/codenameyau/dotfiles/blob/master/provision/osx/setup.sh

### iTerm2
- Download iTerm2
- Import profile from https://github.com/codenameyau/dotfiles/blob/master/provision/iterm2-profile.json
- Remap iTerm2 `alt+left` and `alt+right` to escape sequence `esc+b` and `esc+f` in `Profiles > Default > Keys`.

## Python Installation

### Setting python3 by default on mac

This should install python3.
```sh
# See available versions of python.
brew search python

# Installs latest python.
brew install python

# Installs specific version of python.
brew install python@3.8
```

Unlink and link with brew.
```sh
brew unlink python

# Basically all you need to do:
brew link --force python@3.8

# OR force the link and overwrite all conflicting files:
brew link --force --overwrite python@3.8

# OR if needed list all files that would be deleted:
brew link --overwrite --dry-run python@3.8
```

Update symlinks without brew.

```sh
# See all the symbolic links for python.
ls -l /usr/local/bin/python*

# Run this command to link python3 to python.
ln -s /usr/local/bin/python3 /usr/local/bin/python

# To delete this link, run this. Then open a new terminal.
rm /usr/local/bin/python
```


## Ruby Installation

#### Install Brew and brew packages
```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew update
brew doctor
```

#### Install RVM
```bash
brew install redis
brew install gpg

# Install security key for RVM
command curl -sSL https://rvm.io/mpapis.asc | gpg --import -

# Install RVM and update to latest package
curl -L https://get.rvm.io | sudo bash -s stable
rvm get stable --autolibs=enable
source ~/.rvm/scripts/rvm
```

#### Install Ruby and Gem
```bash
# Install Ruby
rvm install ruby-2.2.7
rvm use 2.2.7 --default
ruby -v

# Update gem
gem -v
gem update --system
rvm gemset use global
gem outdated
gem update

# Install bundler to manage gem for rails
gem install bundler
```

#### Install Ruby on Rails
```bash
rvm use ruby-2.2.7@rails4.2.8 --create
gem install rails --version=4.2.8
rails -v
```
