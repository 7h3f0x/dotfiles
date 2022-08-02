" Netrw:{{{

" Don't show hidden files by default
let ghregex = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide = ghregex
let g:netrw_special_syntax = 1

" https://superuser.com/a/1317266
" Use gx to open url in browser, for WSL
if getenv("IS_WSL")
    let g:netrw_browsex_viewer = 'cmd.exe /C start'
endif

" }}}

" Markdown:{{{

let g:markdown_fenced_languages = ['c', 'cpp', 'java', 'go', 'python', 'bash=sh', 'sh', 'javascript', 'js=javascript', 'php', 'vim', 'man', 'cmake', 'lua']
let g:markdown_folding = 1

" }}}

" Python3:{{{

" Allow using python3 omnifunc with virtual environments
let g:python3_host_prog = '/usr/bin/python3'
if has('python3') && exists("$VIRTUAL_ENV")
python3 << EOF
import sys
import os

sys.path.append(os.path.join(os.environ.get('VIRTUAL_ENV'), 'lib/python3.8/site-packages'))

EOF
end

" }}}

" vim:foldmethod=marker
