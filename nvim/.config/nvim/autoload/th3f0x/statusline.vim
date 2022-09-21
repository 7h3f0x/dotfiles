let s:padding = " "

let s:mode_map = {
            \ 'n': 'NORMAL',
            \ 'i': 'INSERT',
            \ 'v': 'VISUAL',
            \ 'V': 'V-LINE',
            \ '':'V-BLOCK',
            \ 'c': 'COMMAND',
            \ 'R': 'REPLACE',
            \ 't': 'TERMINAL'
            \}

let s:hl_map = {
            \ 'N': '1',
            \ 'I': '2',
            \ 'V': '3',
            \ 'R': '4',
            \ 'C': '5',
            \}

" Current Vim Mode
function s:component_mode(is_active)
    let curr_mode = mode()
    let curr_mode = get(s:mode_map, curr_mode, "NORMAL?")
    let hl = get(s:hl_map, curr_mode[0], '1')

    let component = ''
    let component .= "%" . hl . '*'
    let component .= s:padding
    let component .= curr_mode
    let component .= s:padding

    return component
endfunction

" Current Git Branch / Commit Info
function s:component_git(is_active)
    let component = ''

    if exists("*FugitiveHead")
        let head = FugitiveHead()
        if head != ''
            let component .= "%6*"
            let component .= s:padding
            let component .= ' '
            let component .= head
            let component .= s:padding
        endif
    endif

    return component
endfunction

" Relative Filename
function s:component_filename(is_active)
    let component = ''

    let component .= "%*"
    let component .= s:padding

    let fname_maxwidth = winwidth(0) / 2
    let component .="%." . fname_maxwidth . "f"

    return component
endfunction

" Flags
function s:component_flags(is_active)
    let component = ''

    let component .= "%*"
    let component .= "%m"
    let component .= "%r"
    let component .= "%h"
    let component .= "%w"

    return component
endfunction

" Current Filetype
function s:component_filetype(is_active)
    let component = ''

    if &filetype != ''
        if a:is_active
            let component = "%6*"
        else
            let component = "%*"
        endif
        let component .= s:padding
        if get(g:, 'loaded_devicons', 0)
            let icon = v:lua.require("nvim-web-devicons").get_icon_by_filetype(&filetype, {'default': v:true})
            let component .= icon . ' '
        endif
        let component .= "%-{&filetype}"
        let component .= s:padding
    endif

    return component
endfunction

" Location in current file
function s:component_location(is_active)
    let component = ''

    if a:is_active
        let curr_mode = mode()
        let curr_mode = get(s:mode_map, curr_mode, "NORMAL?")
        let hl = get(s:hl_map, curr_mode[0], '1')
        let component .= "%" . hl . '*'
    else
        let component .= "%*"
    endif

    let component .= s:padding
    let component .= " %-l:%-c"
    let component .= s:padding

    return component
endfunction

function s:component_lsp(is_active)
    if a:is_active
        if luaeval('#vim.lsp.buf_get_clients() > 0')
            return v:lua.require('lsp-status').status()
        endif
    endif
    return ''
endfunction

let s:component_map = {
            \ 'mode': function('s:component_mode'),
            \ 'git': function('s:component_git'),
            \ 'filename': function('s:component_filename'),
            \ 'flags': function('s:component_flags'),
            \ 'filetype': function('s:component_filetype'),
            \ 'location': function('s:component_location'),
            \ 'filename_flags' : { is_active -> s:component_filename(is_active) . s:component_flags(is_active) },
            \ 'lsp': function('s:component_lsp')
            \}

function th3f0x#statusline#statusline(is_active)
    let statusline = ''

    let active = a:is_active ? "active" : "inactive"

    let components = g:statusline_components[active]
    let component_separator = g:statusline_components['separator']
    let l:left = map(copy(components.left), {_, val -> s:component_map[val](a:is_active)})
    call filter(l:left, {_, val -> val != ''})

    let statusline .= join(l:left, l:component_separator.left)

    " Section Separation
    let statusline .= "%="

    let l:right = map(copy(components.right), {_, val -> s:component_map[val](a:is_active)})
    call filter(l:right, {_, val -> val != ''})

    let statusline .= join(l:right, l:component_separator.right)

    return statusline
endfunction
