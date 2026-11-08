# vim

[`.vimrc`](.vimrc) is a small Vim config that uses the
[Vundle](https://github.com/VundleVim/Vundle.vim) plugin manager.

## Installation

```bash
curl -fsSL -o ~/.vimrc https://raw.githubusercontent.com/codenameyau/dotfiles/master/vim/.vimrc
```

```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

Then install the plugins, either from the shell:

```bash
vim +PluginInstall +qall
```

or by opening vim (ignore the first-run errors about missing plugins) and running:

```vim
:PluginInstall
```

`provision/osx/setup.sh` runs these same steps.

### Vundle commands

| Command | Action |
| ------- | ------ |
| `:PluginList` | List configured plugins |
| `:PluginInstall` | Install plugins (`:PluginInstall!` or `:PluginUpdate` to update) |
| `:PluginSearch foo` | Search for plugins (`!` refreshes the cache) |
| `:PluginClean` | Remove plugins no longer listed in `.vimrc` (`!` skips confirmation) |

## Plugins

| Plugin | What it does | Status and alternative |
| ------ | ------------ | ---------------------- |
| [ctrlpvim/ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim) | Fuzzy file finder on <kbd>Ctrl</kbd>+<kbd>P</kbd> | Maintained fork of the original `kien/ctrlp.vim`. [fzf.vim](https://github.com/junegunn/fzf.vim) is faster on large repos. |
| [airblade/vim-gitgutter](https://github.com/airblade/vim-gitgutter) | Shows added/changed/removed lines in the sign column | Maintained |
| [vim-airline/vim-airline](https://github.com/vim-airline/vim-airline) | Status line with mode, branch, and file info | Maintained |
| [mattn/emmet-vim](https://github.com/mattn/emmet-vim) | Emmet HTML/CSS abbreviations (`div.box` then <kbd>Ctrl</kbd>+<kbd>Y</kbd> <kbd>,</kbd>) | Maintained |
| [dense-analysis/ale](https://github.com/dense-analysis/ale) | Runs linters (eslint, shellcheck, flake8, ...) asynchronously as you type and shows errors in the sign column | Replaces syntastic, whose author recommends ALE. Uses whichever linters are installed; no setup needed. |
| [mg979/vim-visual-multi](https://github.com/mg979/vim-visual-multi) | Multiple cursors: <kbd>Ctrl</kbd>+<kbd>N</kbd> selects the word and then each next match | Replaces vim-multiple-cursors, which is deprecated in its favor |

Commented out in `.vimrc`: [vim-fugitive](https://github.com/tpope/vim-fugitive) (git
commands inside vim) and [YouCompleteMe](https://github.com/ycm-core/YouCompleteMe)
(code completion).

If you installed the older plugins (`kien/ctrlp.vim`, `scrooloose/syntastic`,
`terryma/vim-multiple-cursors`), switch with `vim +PluginClean! +PluginInstall +qall`.

Vundle itself hasn't had a release in years. If you start fresh,
[vim-plug](https://github.com/junegunn/vim-plug) is the most widely used plugin manager,
and Vim 8+ / Neovim can load plugins with no manager at all by cloning them into
`~/.vim/pack/plugins/start/` (see `:help packages`).

### YouCompleteMe

If you enable YouCompleteMe, it needs a compiled component. It takes several minutes
and requires CMake and Python 3:

```bash
sudo apt install -y build-essential cmake python3-dev   # macOS: brew install cmake python
```

```bash
cd ~/.vim/bundle/YouCompleteMe && python3 install.py --all
```

`--all` builds support for every language and needs Go, Node, Rust, and a JDK. Use
flags such as `--clangd-completer --ts-completer` to build only what you need. Lighter
alternatives are [coc.nvim](https://github.com/neoclide/coc.nvim) or Neovim's built-in
LSP client.

## Settings

| Setting | Effect |
| ------- | ------ |
| `wildignore` | Skip `.git`, `.hg`, `.svn`, `*.pyc`, `.DS_Store`, `*~`, `node_modules`, `bower_components`, `vendor` in file completion and CtrlP |
| `syntax on` | Syntax highlighting |
| `hidden` | Switch buffers without saving first |
| `autowriteall` | Save automatically when switching buffers or running `:make` |
| `wildmenu`, `showcmd` | Menu for command-line completion; show partial commands |
| `hlsearch`, `incsearch` | Highlight matches and search as you type (`:noh` clears) |
| `autoindent`, `smarttab`, `shiftwidth=2`, `softtabstop=2`, `expandtab` | 2-space indentation with spaces |
| `ignorecase`, `smartcase` | Case-insensitive search unless the pattern has a capital letter |
| `backspace=indent,eol,start` | Backspace works over indentation and line breaks |
| `nostartofline` | Keep the cursor column when jumping |
| `number`, `ruler`, `laststatus=2`, `cmdheight=2` | Line numbers, cursor position, always show the status line, 2-line command area |
| `confirm` | Ask to save instead of failing on `:q` with unsaved changes |
| `visualbell`, `t_vb=` | No beeping or flashing |
| `mouse=a` | Mouse support in all modes |
| `notimeout ttimeout ttimeoutlen=200` | Mappings never time out; key codes time out after 200 ms |
| `imap jj <Esc>`, `imap kk <Esc>` | Type `jj` or `kk` in insert mode to return to normal mode |

## Keyboard shortcuts

Normal mode unless noted.

| Keys | Action |
| ---- | ------ |
| <kbd>I</kbd> | Insert at the start of the line |
| <kbd>A</kbd> | Append at the end of the line |
| <kbd>o</kbd> / <kbd>O</kbd> | Open a new line below / above |
| <kbd>J</kbd> | Join the next line onto this one with a space |
| `<num>G` or `<num>gg` | Go to line `<num>` (`gg` alone: first line; `G` alone: last line) |
| <kbd>Ctrl</kbd>+<kbd>P</kbd> | Fuzzy-find a file (CtrlP plugin) |
| `dd` / `yy` / `p` | Cut / copy (yank) / paste a line |
| `u` / <kbd>Ctrl</kbd>+<kbd>R</kbd> | Undo / redo |
| `.` | Repeat the last change |
| `vip` | Select the current paragraph / block |
| `ciw` / `ci"` | Change the word / text inside quotes |
| `*` | Search for the word under the cursor |
| `:%s/old/new/g` | Replace all occurrences (`gc` to confirm each) |
| `ZZ` | Save and quit (`:wq`); `ZQ` quits without saving (`:q!`) |
| <kbd>Ctrl</kbd>+<kbd>N</kbd> | Select the word, then each next occurrence, for multi-edit (vim-visual-multi); <kbd>Esc</kbd> to exit |

Comment out several lines with a visual block:

1. <kbd>Ctrl</kbd>+<kbd>V</kbd> and move up or down to select lines.
2. <kbd>Shift</kbd>+<kbd>I</kbd>, type `# `, then <kbd>Esc</kbd>. The text is inserted on
   every selected line.
3. To uncomment, select the comment characters with <kbd>Ctrl</kbd>+<kbd>V</kbd> and press
   <kbd>x</kbd>.

Run `vimtutor` in a terminal for a 30-minute interactive introduction.
