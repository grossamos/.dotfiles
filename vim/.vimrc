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
Plug 'arrufat/vala.vim'
Plug 'preservim/nerdtree'
Plug 'alvan/vim-closetag'
Plug 'junegunn/fzf'
Plug 'preservim/tagbar'
Plug 'morhetz/gruvbox'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/tagbar'

call plug#end()

set background=dark
let mapleader = " "
colorscheme gruvbox

"Autocomplete
inoremap {<CR> {<CR>}<C-o>O
au FileType html let b:loaded_delimitMate = 1

"snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-l>"


" Move Blocks up and down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Change windows
nmap <C-Up> :wincmd k<CR>
nmap <C-Down> :wincmd j<CR>
nmap <C-Left> :wincmd h<CR>
nmap <C-Right> :wincmd l<CR>

"shift tab
inoremap <S-Tab> <C-d>

" ------------------------
" IDE functionality for vim
" -------------------------

" Init IDE with leader+n
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>m :FZF<CR>
nnoremap <leader>, :TagbarToggle<CR>

" NERDTee stuff
let NERDTreeShowHidden=1
" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Stuff for tagbar to work with vala
let g:tagbar_ctags_bin = "anjuta-tags"
let type_vala = {}
let type_vala.ctagstype = 'vala'
let type_vala.kinds = [
 \ {'short' : 'c', 'long' : 'classes', 'fold' : 0},
 \ {'short' : 'd', 'long' : 'delegates', 'fold' : 0},
 \ {'short' : 'e', 'long' : 'enumerations', 'fold' : 0},
 \ {'short' : 'E', 'long' : 'error domains', 'fold' : 0},
 \ {'short' : 'f', 'long' : 'fields', 'fold' : 0},
 \ {'short' : 'i', 'long' : 'interfaces', 'fold' : 0},
 \ {'short' : 'm', 'long' : 'methods', 'fold' : 0},
 \ {'short' : 'p', 'long' : 'properties', 'fold' : 0},
 \ {'short' : 'r', 'long' : 'error codes', 'fold' : 0},
 \ {'short' : 's', 'long' : 'structures', 'fold' : 0},
 \ {'short' : 'S', 'long' : 'signals', 'fold' : 0},
 \ {'short' : 'v', 'long' : 'enumeration values', 'fold' : 0}
 \ ]
let type_vala.sro = '.'
let type_vala.kind2scope = {
 \ 'i' : 'interface',
 \ 'c' : 'class',
 \ 's' : 'structure',
 \ 'e' : 'enum'
 \ }
let type_vala.scope2kind = {
 \ 'interface' : 'i',
 \ 'class' : 'c',
 \ 'struct' : 's',
 \ 'enum' : 'e'
 \ }
