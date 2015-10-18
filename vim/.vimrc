"----------------------------------------------------------
" Vim Plugins
"----------------------------------------------------------
set runtimepath^=~/.vim/bundle/ctrlp.vim


"----------------------------------------------------------
" File Ignores
"----------------------------------------------------------

" Ignore version control directories.
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*

" Ignore compiled files.
set wildignore+=*.pyc*

" Ignore miscellaneous files.
set wildignore+=*/.DS_Store,*~

" Ignore packages.
set wildignore+=*node_modules*,*bower_components*,*/vendor,


"----------------------------------------------------------
" Colorschemes
"----------------------------------------------------------
syntax on
colorscheme molokai
set t_Co=256
hi Normal ctermfg=252 ctermbg=none
let g:molokai_original = 1


"----------------------------------------------------------
" System Settings
"----------------------------------------------------------
set nocompatible
set hidden
set autowriteall
set wildmenu
set showcmd
set hlsearch
set incsearch


"----------------------------------------------------------
" Indentation
"----------------------------------------------------------
filetype indent plugin on
set autoindent
set smarttab
set shiftwidth=2
set softtabstop=2
set expandtab


"----------------------------------------------------------
" Text Options
"----------------------------------------------------------
set ignorecase
set smartcase
set backspace=indent,eol,start
set nostartofline


"----------------------------------------------------------
" Editor Options
"----------------------------------------------------------
set number
set ruler
set laststatus=2
set cmdheight=2
set confirm
set visualbell
set mouse=a
set t_vb=

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200


"----------------------------------------------------------
" Mapping Keystrokes
"----------------------------------------------------------
:imap jj <Esc>
:imap uu <BS>
:imap hh <Enter>
