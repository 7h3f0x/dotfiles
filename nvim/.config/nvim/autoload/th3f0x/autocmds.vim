function! th3f0x#autocmds#clean_whitespace() abort
    if &filetype == 'markdown'
        return
    endif
    if &modifiable == 1
        let l:view = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:view)
    endif
endfunction

function th3f0x#autocmds#highlights() abort
    highlight def iCursor guibg=white ctermbg=white

    highlight def BlackFloat       guibg=black ctermbg=black
    highlight def BlackFloatBorder guibg=black ctermbg=black

    highlight! link InactiveNormal CursorLine
endfunction

