"----------------------------------------------------------
" Plugins
"----------------------------------------------------------
set runtimepath^=~/.vim/bundle/ctrlp.vim


"----------------------------------------------------------
" Colorschemes
"----------------------------------------------------------
syntax on
colorscheme molokai
set t_Co=256
hi Normal ctermfg=252 ctermbg=none


"----------------------------------------------------------
" Mapping Keystrokes
"----------------------------------------------------------
:imap jj <Esc>


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

" Time out on keycodes, but never on mappings
set notimeout ttimeout ttimeoutlen=200


"----------------------------------------------------------
" Disable arrows
"----------------------------------------------------------
"inoremap  <Up>     <NOP>
"inoremap  <Down>   <NOP>
"inoremap  <Left>   <NOP>
"inoremap  <Right>  <NOP>
"noremap   <Up>     <NOP>
"noremap   <Down>   <NOP>
"noremap   <Left>   <NOP>
"noremap   <Right>  <NOP>
