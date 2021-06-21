set iskeyword+=-
set formatoptions-=cro

syntax enable
set nu rnu " relative line numbering
set clipboard=unnamed " public copy/paste register
set ruler
set showcmd
set noswapfile " doesn't create swap files
set noshowmode
set shortmess+=c
set omnifunc=syntaxcomplete#Complete
set cursorline
set mouse=a
set splitbelow
set splitright
set completeopt=menuone,noselect

set backspace=indent,eol,start " let backspace delete over lines
set autoindent " enable auto indentation of lines
set smartindent " allow vim to best-effort guess the indentation
set tabstop=2
set shiftwidth=2
set smarttab
set expandtab
set textwidth=120

set wildmenu "graphical auto complete menu
set lazyredraw "redraws the screne when it needs to
set showmatch "highlights matching brackets
set incsearch "search as characters are entered
set hlsearch "highlights matching searches

set showtabline=2
set updatetime=300
set timeoutlen=200
set guifont=FiraCode\ Nerd\ Font\ Mono

set nobackup
set nowritebackup
set signcolumn=yes
set nowrap
set encoding=utf-8
set fileencoding=utf-8
set hidden

set background=dark
set t_Co=256
set laststatus=2

set foldmethod=indent
set foldlevel=20

