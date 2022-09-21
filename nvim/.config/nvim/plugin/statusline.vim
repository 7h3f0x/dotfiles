let g:statusline_components = {
            \ 'active': {
            \       'left': ['mode', 'git', 'filename_flags'],
            \       'right': ['lsp', 'filetype', 'location'],
            \   },
            \ 'inactive': {
            \       'left': ['filename_flags'],
            \       'right': ['filetype', 'location'],
            \   },
            \ 'separator': {
            \       'left': '',
            \       'right': '',
            \   },
            \}

set noshowmode
set statusline=%!th3f0x#statusline#statusline(1)

augroup statusline_active
    autocmd!
    autocmd WinEnter * setlocal statusline=%!th3f0x#statusline#statusline(1)
    autocmd WinLeave * setlocal statusline=%!th3f0x#statusline#statusline(0)
    autocmd FileType qf setlocal statusline=%!th3f0x#statusline#statusline(1)
augroup END

