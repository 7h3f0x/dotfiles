" Vim Plug Section:{{{1

" Install vim-plug if I don't already have it
let s:data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(s:data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo ' . s:data_dir . '/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    silent execute '!curl -fLo ' . s:data_dir . '/doc/plug.txt --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/doc/plug.txt'
    silent helptags ALL
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin(stdpath('data') . '/plugged')

if !has("nvim-0.7")
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'commit': 'bc25a6a5c4fd659bbf78ba0a2442ecf14eb00398'}
else
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif

Plug 'nvim-treesitter/playground', {'on': [ 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' ]}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'L3MON4D3/LuaSnip'
if !has("nvim-0.7")
    Plug 'saadparwaiz1/cmp_luasnip', {'commit': 'b10829736542e7cc9291e60bab134df1273165c9'}
else
    Plug 'saadparwaiz1/cmp_luasnip'
endif
if !has('nvim-0.6')
    Plug 'nvim-lua/lsp-status.nvim', {'commit': 'e8e5303f9ee3d8dc327c97891eaa1257ba5d4eee'}
else
    Plug 'nvim-lua/lsp-status.nvim'
    Plug 'j-hui/fidget.nvim'
    Plug 'lewis6991/impatient.nvim'
endif
Plug 'onsails/lspkind-nvim'

Plug 'windwp/nvim-autopairs'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'ii14/onedark.nvim'
Plug 'rcarriga/nvim-notify'

Plug '~/projects/indentpython.vim'

Plug 'junegunn/fzf', {'dir': '~/tools/fzf', 'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'nvim-lualine/lualine.nvim'
" https://github.com/neovim/neovim/issues/12587
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'mbbill/undotree'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

Plug 'dstein64/vim-startuptime', { 'on': 'StartupTime' }

Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

call plug#end()

" 1}}}

lua pcall(require, 'impatient')
let g:cursorhold_updatetime = 1000

" vim:foldmethod=marker

