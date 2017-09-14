# provision

## Mac Setup

Run automated script: https://github.com/codenameyau/dotfiles/blob/master/provision/osx.sh

Install bash completion
```bash
brew install bash-completion

# Add to .bashrc or .bash_profile
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi
```

Install shiny prompt
```
wget https://raw.githubusercontent.com/codenameyau/shiny-prompt/master/src/.bash_prompt && echo "source ~/.bash_prompt" >> "~/.bash_profile"
```

### Update Default Mac Settings
- Hide Dock: `System Preferences > Dock`
- Switch off sorting desktop by frequency: http://www.macobserver.com/tmo/answers/prevent_lions_spaces_from_automatically_changing_order


### Map Keyboard Shortcuts
- Remap terminal keyboard shortcuts: https://stackoverflow.com/a/81299
- Remap Terminal `cmd+left` and `cmd+right` to escape sequence `esc+b` and `esc+f`
- Remap `cmd+q` to set inverse colors in accessibility.

## Dev Setup

- Setup GitHub SSH key: https://help.github.com/articles/connecting-to-github-with-ssh/
- Setup GitHub GPG Key: https://help.github.com/articles/signing-commits-with-gpg/
- Install Atom: https://atom.io/
- Install VSCode: https://code.visualstudio.com/
- Syntax highlight with less: https://ole.michelsen.dk/blog/syntax-highlight-files-macos-terminal-less.html
- Update dotfiles and git hooks: https://github.com/codenameyau/dotfiles

## App Installation
- Install licecap: https://github.com/justinfrankel/licecap
- Install postman: https://www.getpostman.com/
- Install GitKraken: https://www.gitkraken.com/
