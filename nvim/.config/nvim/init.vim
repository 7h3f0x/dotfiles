" Vim Plug Section:{{{1

let s:data_dir = stdpath('data') . '/site'

if !empty(glob(s:data_dir . '/autoload/plug.vim')) && !(v:progname == 'vim')
    call plug#begin(stdpath('data') . '/plugged')

    Plug 'joshdick/onedark.vim'

    Plug 'junegunn/fzf', {'dir': '~/tools/fzf', 'do': { -> fzf#install() }}
    Plug 'junegunn/fzf.vim'


    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'

    Plug 'mbbill/undotree'
    Plug 'dstein64/vim-startuptime', { 'on': 'StartupTime' }


    call plug#end()
endif

" 1}}}

lua require("7h3f0x.utils")

" vim:foldmethod=marker

