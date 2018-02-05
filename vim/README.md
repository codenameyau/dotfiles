# vim

### Installation

In terminal run:
```bash
wget https://raw.githubusercontent.com/codenameyau/dotfiles/master/vim/.vimrc -P ~
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Then open vim (ignore errors) and run:
```vim
:PluginInstall
```

### Additional Plugins

Compile [YouCompleteMe](https://github.com/valloric/youcompleteme#installation)
```bash
# It usually takes about 5 minutes to complete.
sudo apt-get install -y cmake
cd ~/.vim/bundle/youcompleteme
python install.py --all
```

### Keyboard shortcuts

```bash
# Move to beginning of line and switch to insert mode (I=insert)
shift-i

# Move to end of line and switch to insert mode (A=append)
shift-a

# Join newlines into one line separated by space (J=join)
shift-j

# Jump to line (G=goto)
<num> + shift-g
<num> + gg

# Comment multiple lines with visual block.
ctrl-v
<move cursor up/down>
shift-i
<# for comment / x to uncomment>
esc

# Save and exit vim
ZZ

# Cut line.
dd

# Select block of code.
vip

# Substitute all ocurrences
:%s/string/replaced_string/g

# [plugin] Multi-edit.
ctr-n
```
