function! th3f0x#commands#messages_helper(command) abort
    let l:tmpfile = tempname()
    execute "redir > " . l:tmpfile
    silent! execute a:command
    redir END
    execute float2nr(floor(&lines * 0.3)) . "split " . l:tmpfile
endfunction

function! th3f0x#commands#transparent_helper(restore) abort
    if a:restore == 1
        let g:is_transparent = v:false
        execute 'colorscheme ' . g:colors_name
        highlight BlackFloat       guibg=black ctermbg=black
        highlight BlackFloatBorder guibg=black ctermbg=black
    else
        let g:is_transparent = v:true
        highlight Normal ctermbg=None guibg=None
        highlight InactiveWin ctermbg=None guibg=None
        highlight BlackFloat       guibg=none ctermbg=none
        highlight BlackFloatBorder guibg=none ctermbg=none
        highlight NormalFloat      guibg=none ctermbg=none
        highlight CursorLine ctermbg=None guibg=None
    endif
endfunction
