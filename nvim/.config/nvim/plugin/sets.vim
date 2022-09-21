set number
set relativenumber

set shiftwidth=4
set tabstop=4
set softtabstop=4
set expandtab

set termguicolors
set cursorline

set undolevels=2000
set undofile

set ignorecase
set smartcase

set splitbelow
set splitright

set hidden
set pumheight=10
set formatoptions+=cr
set commentstring=//\ %s
set mouse=a

" Show as much of the last line as possible(in case of very long lines)
set display+=lastline
" Show effects of a substitute command incrementally
" (e.g - use :%s.. to see the effects)
set inccommand=split

" Insert-Mode cursor should have white color always
set guicursor=n-v-c-sm:block,i-ci-ve:ver25-iCursor,r-cr-o:hor20

set foldlevelstart=99

set backupcopy=yes

set noequalalways

set completefunc=syntaxcomplete#Complete
set completeopt-=preview

set scrolloff=12

set wildcharm=<C-n>
let &wildmode = "longest:full,full"
set colorcolumn=80,120

set grepprg=grep\ -nH
