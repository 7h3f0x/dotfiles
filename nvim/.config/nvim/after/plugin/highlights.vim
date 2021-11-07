augroup color_scheme
    autocmd!
    autocmd ColorScheme onedark call th3f0x#highlights#highlight_onedark()
    " The lua version of onedark basically does `lua require'onedark'`
    " The package is already loaded, files won't be sourced again, if I dont
    " force it to reload using this technique
    autocmd ColorSchemePre onedark lua package.loaded['onedark'] = nil
augroup END

try
    let g:onedark_terminal_italics = 1
    colorscheme onedark
catch /^Vim\%((\a\+)\)\=:E185/

endtry

highlight def iCursor guibg=white ctermbg=white

highlight def BlackFloat       guibg=black ctermbg=black
highlight def BlackFloatBorder guibg=black ctermbg=black

highlight CursorLineNr cterm=bold gui=bold

