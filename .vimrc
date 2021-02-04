syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch

set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey

call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'sheerun/vim-polyglot'
Plug 'mxw/vim-prolog'
Plug 'luochen1990/rainbow'

call plug#end()

colorscheme gruvbox
set background=dark
let mapleader = " "

"Autocomplete
inoremap \[ \[\]<Left>
"inoremap ( ()<Left>
"inoremap \" \"\"<Left>
inoremap { {}<Left>
inoremap \[<CR> \[\]<Esc>i<CR><CR><Esc>ki<Tab>
inoremap (<CR> ()<Esc>i<CR><CR><Esc>ki<Tab>
inoremap {<CR> {}<Esc>i<CR><CR><Esc>ki<Tab>
inoremap <expr> \] getline('.')\[getpos('.')\[2\] - 1\] == '\]' ? '<Right>' : '\]'
inoremap <expr> ) getline('.')\[getpos('.')\[2\] - 1\] == ')' ? '<Right>' : ')'
inoremap <expr> } getline('.')\[getpos('.')\[2\] - 1\] == '}' ? '<Right>' : '}'

"shift tab
inoremap <S-Tab> <C-d>
