augroup color_scheme
    autocmd!
    autocmd ColorScheme onedark if g:colors_name == expand("<amatch>") | call th3f0x#highlights#onedark#highlight() | endif
augroup END

try
    let g:onedark_terminal_italics = 1
    colorscheme onedark
catch /^Vim\%((\a\+)\)\=:E185/

endtry
highlight def iCursor guibg=white ctermbg=white

highlight def BlackFloat       guibg=black ctermbg=black
highlight def BlackFloatBorder guibg=black ctermbg=black


