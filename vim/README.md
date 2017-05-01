# vim

### Installation

In terminal run:
```bash
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/vim/.vimrc ~/.vimrc
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Then open vim and run:
```vim
:source %
:PluginInstall
```

Follow installation to compile [YouCompleteMe](https://github.com/valloric/youcompleteme#installation)
```bash
cd ~/.vim/bundle/youcompleteme
./install.py --all
```

### Keyboard shortcuts

```bash
# Move to beginning of line and switch to insert mode.
shift-i

# Move to end of line and switch to insert mode.
shift-a

# Jump to line.
<num> + shift-g
<num> + gg

# Join newlines into one line separated by space.
shift-j

# [plugin] Multi-edit.
ctr-n

# Select block of code.
vip
```
