
function! th3f0x#fzf#live_grep(query, fullscreen) abort
    let l:command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
    let l:initial_command = printf(l:command_fmt, shellescape(a:query))
    let l:reload_command = printf(l:command_fmt, '{q}')
    let l:prev_win = g:fzf_preview_window
    let g:fzf_preview_window = ['down:55%', 'ctrl-/']
    let l:spec = {'options': ['--prompt', "LiveGrep❯ ", '--phony', '--query', a:query, '--bind', 'change:reload:' . l:reload_command]}
    call fzf#vim#grep(l:initial_command, 1, fzf#vim#with_preview(l:spec), a:fullscreen)
    let g:fzf_preview_window = l:prev_win
endfunction

function! th3f0x#fzf#build_quickfix_qf(lines) abort
    let l:lines = map(copy(a:lines[1:]), 'split(v:val, ":")')
    let l:cmd = get(get(g:, "fzf_action", {'ctrl-x': 'split',
                \ 'ctrl-v': 'vertical split',
                \ 'ctrl-t': 'tabedit'}), a:lines[0], 'edit')
    if len(a:lines) > 2
        call setqflist(map(copy(l:lines), '{ "filename": v:val[0], "lnum": v:val[1], "col":v:val[2], "text": len(v:val) > 3 ? v:val[3] : ""}'))
        copen
        cc
    else
        execute l:cmd . " " . l:lines[0][0] . " | :" . l:lines[0][1] . "| norm ". l:lines[0][2] . "|"
    endif
endfunction

function! th3f0x#fzf#find_files_ff(args, fullscreen) abort
    let l:saved = $FZF_DEFAULT_COMMAND
    let $FZF_DEFAULT_COMMAND = "rg --files --hidden -g '!{.git}'"
    call fzf#vim#files(a:args, fzf#vim#with_preview({'options': ['--prompt', "Files❯ "]}), a:fullscreen)
    let $FZF_DEFAULT_COMMAND = l:saved
endfunction

function! th3f0x#fzf#grep_files(source) abort
    if executable('rg')
        let l:grep_cmd = "rg --column --line-number --no-heading --color=always --smart-case -- "
    else
        let l:grep_cmd = "grep --recursive -i --line-number --perl-regexp --color=always -- "
    endif
    call fzf#vim#grep(
                \ l:grep_cmd . shellescape(a:source),
                \ 1,
                \ fzf#vim#with_preview({ 'options': ['--prompt', 'Search❯ '] }),
                \ 0)
endfunction

function s:fzf_man_cb(line) abort
    let l:args = split(a:line)
    execute 'Man ' . l:args[0] . l:args[1]
endfunction

function th3f0x#fzf#fzf_man_pages(fullscreen) abort
    let wrapped = fzf#wrap('ManPages', {
                \   'source': 'apropos ""',
                \   'sink': function('s:fzf_man_cb'),
                \   'options': ['--prompt', "ManPages❯ ", "--tiebreak=begin", '--delimiter', '\(|\)', '--preview', 'MANWIDTH=$FZF_PREVIEW_COLUMNS man {2} {1} | batcat -p -l man --color=always']
                \}, a:fullscreen)
    call fzf#run(wrapped)
endfunction

" }}}

