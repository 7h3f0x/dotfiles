" In termguicolors, make some things better looking
" (by default, poor visibility)
highlight Pmenu guifg=black
highlight PmenuSel guifg=black
highlight TabLine guifg=black
highlight Folded guibg=Grey42
highlight Visual guibg=Grey42

" Differentiate current split with other splits, based on background color
augroup ActiveWin
    autocmd!
    autocmd WinEnter * setlocal winhl=
    autocmd WinLeave * setlocal winhl=Normal:InactiveNormal
augroup END

