"--------------------------------------------------------------------
" VundleVim
"--------------------------------------------------------------------
set nocompatible  " required
filetype off      " required

" Set the runtime path to include Vundle and initialize.
set rtp+=~/.vim/bundle/Vundle.vim

" Customize path: vundle#begin('~/some/path/here')
" Keep Plugin commands between vundle#begin/end.
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

"--------------------------------------------------------------------
" Place all plugins here. Here are examples of different formats
"--------------------------------------------------------------------

Plugin 'kien/ctrlp.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'mattn/emmet-vim'
Plugin 'scrooloose/syntastic'
Plugin 'terryma/vim-multiple-cursors'

" Plugin on GitHub repo.
" Plugin 'tpope/vim-fugitive'

" Large plugin for auto completion.
" Plugin 'valloric/youcompleteme'

" Plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'

" Git plugin not hosted on GitHub.
" Plugin 'git://git.wincent.com/command-t.git'

" Git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

"--------------------------------------------------------------------
" All plugins should be placed before this line
"--------------------------------------------------------------------
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ

"--------------------------------------------------------------------
" File Ignores
"--------------------------------------------------------------------

" Ignore version control directories.
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*

" Ignore compiled files.
set wildignore+=*.pyc*

" Ignore miscellaneous files.
set wildignore+=*/.DS_Store,*~

" Ignore packages.
set wildignore+=*node_modules*,*bower_components*,*/vendor,

"--------------------------------------------------------------------
" Colorschemes
"--------------------------------------------------------------------
syntax on

"--------------------------------------------------------------------
" System Settings
"--------------------------------------------------------------------
set nocompatible
set hidden
set autowriteall
set wildmenu
set showcmd
set hlsearch
set incsearch

"--------------------------------------------------------------------
" Indentation
"--------------------------------------------------------------------
set autoindent
set smarttab
set shiftwidth=2
set softtabstop=2
set expandtab

"--------------------------------------------------------------------
" Text Options
"--------------------------------------------------------------------
set ignorecase
set smartcase
set backspace=indent,eol,start
set nostartofline

"--------------------------------------------------------------------
" Editor Options
"--------------------------------------------------------------------
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

"--------------------------------------------------------------------
" Mapping Keystrokes
"--------------------------------------------------------------------
:imap jj <Esc>
:imap kk <Esc>
