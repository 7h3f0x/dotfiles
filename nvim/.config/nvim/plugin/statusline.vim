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
set statusline=%!th3f0x#statusline#statusline()
