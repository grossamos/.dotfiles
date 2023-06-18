syntax on

set noerrorbells

set nu
set relativenumber

set hidden
set smartcase
set incsearch
set nohlsearch
set exrc "source local vimrc (ex. kernel)
filetype plugin indent on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set scrolloff=8
set signcolumn=yes

set title
set noswapfile
set nobackup
set undodir=~/.nvim/undodir
set undofile

" -------------------------------
"            Plugins
" -------------------------------

" Install vim-plug if not found
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'

if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

Plug 'nvim-lua/plenary.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-path'

Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

Plug 'preservim/nerdtree'
Plug 'vim-scripts/AutoClose'
Plug 'itchyny/lightline.vim'
Plug 'preservim/nerdcommenter'
Plug 'mkitt/tabline.vim'
Plug 'bling/vim-bufferline'

Plug 'tpope/vim-sleuth'

call plug#end()

set undodir=~/.nvim/undodir
set undofile

" Run PlugInstall at startup
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" -------------------------------
"          Look and feel
" -------------------------------
colorscheme gruvbox
set cmdheight=1

let mapleader=" "

" statusline
set noshowmode
let g:lightline = {'colorscheme': 'gruvbox'}

let g:lightline.component_function = { 'lineinfo': 'LightlineLineinfo' }

function! LightlineLineinfo() abort
    if winwidth(0) < 86
        return ''
    endif

    let l:current_line = printf('%-3s', line('.'))
    let l:max_line = printf('%-3s', line('$'))
    let l:lineinfo = ' ' . l:current_line . '/' . l:max_line
    return l:lineinfo
endfunction

let g:airline#extensions#tabline#enabled = 1

" -------------------------------
"        IDE functionality
" -------------------------------

"  Unmap annoying keybinds
map K <cmd>lua vim.lsp.buf.hover()<CR>
map <leader>e <cmd>lua vim.diagnostic.open_float()<CR>
map <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
map <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>

" autocomplete
lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  require'cmp'.setup {
  sources = {
      { name = 'path' }
    }
  }

EOF
	


" fuzzy find
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

lua require('telescope').setup{  defaults = { file_ignore_patterns = { "node_modules", ".git", "target" }} }

" file tree
nnoremap <leader>ft :NERDTreeToggle<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" comments
let g:NERDCreateDefaultMappings = 0
nmap <leader>; <plug>NERDCommenterToggle
xmap <leader>; <plug>NERDCommenterToggle

"checklists
nmap <leader>x :ChecklistToggleCheckbox<cr>

" move lines up and down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" move up and down when having line wraps
noremap <silent> k gk
noremap <silent> j gj

" buffers
let g:bufferline_show_bufnr = 0

nnoremap <leader>bn :bn<cr>
nnoremap <leader>bp :bp<cr>
nnoremap <leader>bd :bd<cr>
nnoremap <leader>bl :ls<cr>

" -------------------------------
"             Other
" -------------------------------

" Go back to last position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" TODO
" snippets
" xml/html editing
" parenthesis
" indenting
