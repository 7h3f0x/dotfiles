" Vim Plug Section:{{{1

let s:data_dir = stdpath('data') . '/site'

if !empty(glob(s:data_dir . '/autoload/plug.vim')) && !(v:progname == 'vim')
    call plug#begin(stdpath('data') . '/plugged')

    " Colorscheme
    Plug 'joshdick/onedark.vim'

    " FZF
    Plug 'junegunn/fzf', {'dir': '~/tools/fzf', 'do': { -> fzf#install() }}
    Plug 'junegunn/fzf.vim'


    " Git Integration
    Plug 'tpope/vim-fugitive'

    " Cooment and Uncomment lines
    Plug 'tpope/vim-commentary'

    " Surround text objects and be able to repeat with `.`
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'

    " View and goto undo history
    Plug 'mbbill/undotree'

    " Just to measure staettup time
    Plug 'dstein64/vim-startuptime', { 'on': 'StartupTime' }

    call plug#end()
endif

" 1}}}

lua require("7h3f0x.utils")

" vim:foldmethod=marker

