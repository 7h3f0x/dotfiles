function! th3f0x#highlights#onedark#highlight() abort
    highlight! link vimFunction Function
    highlight! link vimUserFunc Function
    highlight! link vimUsrCmd Identifier

    highlight TablineSel guibg=#98c379 guifg=#282c34
    highlight IncSearch ctermfg=235 ctermbg=39 guifg=#282C34 guibg=#61AFEF

    highlight! link Keyword Statement
    highlight! link FloatBorder NormalFloat
    highlight Comment gui=NONE

    call s:highlight_statusline()

endfunction

function s:highlight_statusline()
    highlight StatusLine guibg=#262626
    highlight! User1 ctermfg=240 ctermbg=76 guifg=#3e4452 guibg=#98c379 cterm=bold gui=bold
    highlight! User2 ctermfg=240 ctermbg=75 guifg=#3e4452 guibg=#61afef cterm=bold gui=bold
    highlight! User3 ctermfg=240 ctermbg=176 guifg=#3e4452 guibg=#c678dd cterm=bold gui=bold
    highlight! User4 ctermfg=240 ctermbg=168 guifg=#3e4452 guibg=#e06c75 cterm=bold gui=bold
    highlight! StatusLineNC guibg=#3e4452 guifg=NONE
    highlight! User5 ctermbg=235 guibg=#3e4452
endfunction

