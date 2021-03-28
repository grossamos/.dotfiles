syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
filetype plugin indent on
set title

call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'sheerun/vim-polyglot'
Plug 'mxw/vim-prolog'
Plug 'luochen1990/rainbow'
Plug 'Raimondi/delimitMate'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

set background=dark
let mapleader = " "

"Autocomplete
inoremap {<CR> {<CR>}<C-o>O

" Move Blocks up and down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

"shift tab
inoremap <S-Tab> <C-d>
