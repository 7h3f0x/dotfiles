function! th3f0x#wsl#yankWinClip() abort
    if v:event.operator ==# 'y' && v:event.regname ==# '+'
        call system('clip.exe', getreg('+'))
    endif
endfunction
