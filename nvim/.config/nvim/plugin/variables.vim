
" Netrw:{{{

" Don't show hidden files by default
let ghregex = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_list_hide = ghregex
let g:netrw_special_syntax = 1

" }}}

" Markdown:{{{

let g:markdown_fenced_languages = ['c', 'cpp', 'java', 'go', 'python', 'bash=sh', 'sh', 'javascript', 'js=javascript', 'php', 'vim', 'man', 'cmake', 'lua']
let g:markdown_folding = 1

" }}}

" vim:foldmethod=marker

