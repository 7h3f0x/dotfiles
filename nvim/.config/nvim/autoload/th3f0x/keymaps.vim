
function! th3f0x#keymaps#save_and_source() abort
    write
    if &filetype ==# "vim"
        silent! source %
    elseif &filetype ==# "lua"
        luafile %
    endif
endfunction

function! th3f0x#keymaps#tmux_helper(direction) abort
    if exists("$TMUX")
        let l:curr = winnr()
        let l:dir = winnr(a:direction)
        if l:curr == l:dir
            let l:command = "tmux select-pane -" . get(g:tmux_dir_map, a:direction)
            call system(l:command)
            return
        endif
    endif
    execute 'wincmd ' . a:direction
endfunction

