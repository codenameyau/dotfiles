# provision

## App Installation
- Install Licecap: https://github.com/justinfrankel/licecap
- Install Postman: https://www.getpostman.com/
- Install GitKraken: https://www.gitkraken.com/
- Install VSCode: https://code.visualstudio.com/

## Dev Setup
- Setup GitHub SSH key: https://help.github.com/articles/connecting-to-github-with-ssh/
- Setup GitHub GPG Key: https://help.github.com/articles/signing-commits-with-gpg/
- Syntax highlight with less: https://ole.michelsen.dk/blog/syntax-highlight-files-macos-terminal-less.html
- Update dotfiles and git hooks: https://github.com/codenameyau/dotfiles

## Mac Setup

### Update Default Mac Settings
- Hide Dock: `System Preferences > Dock`
- Switch off sorting desktop by frequency: http://www.macobserver.com/tmo/answers/prevent_lions_spaces_from_automatically_changing_order

### Map Keyboard Shortcuts
- Remap terminal keyboard shortcuts: https://stackoverflow.com/a/81299
- Remap iTerm2 `alt+left` and `alt+right` to escape sequence `esc+b` and `esc+f` in `Profiles > Default > Keys`. This will not work if you only change global `Keys`.
- Remap `cmd+q` to set inverse colors in accessibility or show desktop.

### Dev Environment Setup

Run automated script: https://github.com/codenameyau/dotfiles/blob/master/provision/osx.sh


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

# Install nokogiri
gem install nokogiri
```

#### Install Ruby on Rails
```bash
rvm use ruby-2.2.7@rails4.2.8 --create
gem install rails --version=4.2.8
rails -v
```
