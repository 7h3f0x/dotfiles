
function! th3f0x#autocmds#clean_whitespace() abort
    if &modifiable == 1
        let l:view = winsaveview()
        keeppatterns %s/\s\+$//e
        call winrestview(l:view)
    endif
endfunction

