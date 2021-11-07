" Commands:{{{

command! Config edit $MYVIMRC

if executable("markdown2html")
    " Preview current markdown file in browser
    command! MarkDownPreview call jobstart(
                \   'markdown2html '
                \   . expand('%')
                \   . ' > .a.html && xdg-open .a.html'
                \ )
endif

command! -nargs=+ -complete=command Cmd call th3f0x#commands#messages_helper(<q-args>)

command! Messages Cmd messages

command! -bang Transparent call th3f0x#commands#transparent_helper(<bang>0)

" }}}

" vim:foldmethod=marker

