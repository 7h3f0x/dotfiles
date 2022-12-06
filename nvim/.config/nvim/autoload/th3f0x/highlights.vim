function th3f0x#highlights#default() abort
    " In termguicolors, make some things better looking
    " (by default, poor visibility)
    highlight Pmenu guifg=black
    highlight PmenuSel guifg=black
    highlight TabLine guifg=black
    highlight Folded guibg=Grey42
    highlight Visual guibg=Grey42

    highlight! link NormalFloat BlackFloat
    highlight! link FloatBorder BlackFloatBorder
endfunction

function th3f0x#highlights#darkplus() abort
    highlight! StatusLine ctermfg=231 guifg=#ffffff ctermbg=235 guibg=#262626 gui=none cterm=none
    highlight! StatusLineNC ctermfg=188 guifg=#d4d4d4 ctermbg=235 guibg=#262626 gui=none cterm=none
    highlight! User1 ctermfg=231 guifg=#ffffff ctermbg=32 guibg=#0A7ACA gui=none cterm=none
    highlight! User2 ctermfg=234 guifg=#1e1e1e ctermbg=214 guibg=#FFAF00 gui=none cterm=none
    highlight! User3 ctermfg=75 guifg=#5CB6F8 ctermbg=237 guibg=#3C3C3C gui=none cterm=none
    highlight! link User4 User2
    highlight! link User5 User1
    highlight! User6 ctermfg=231 guifg=#ffffff ctermbg=236 guibg=#303030 gui=none cterm=none
endfunction
