if !exists("g:loaded_fzf_vim")
    finish
endif

" Variables:{{{

let g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.85 } }
let g:fzf_preview_window = ['right:55%', 'ctrl-/']
let $BAT_THEME='TwoDark'
if executable("rg")
    let $FZF_DEFAULT_COMMAND = 'rg --files --no-ignore-vcs --hidden -L -g "!{.git}"'
else
    let $FZF_DEFAULT_COMMAND = 'find . -type f'
endif
" Remove FZF_DEFAULT_OPTS inherited from shell, use preview window
" only when needed, not in all fzf.vim commands, also reverse layout
let $FZF_DEFAULT_OPTS='--color dark,hl:166,hl+:166 --reverse --bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-j:preview-down,ctrl-k:preview-up,ctrl-g:first'


" }}}


" Commands:{{{

" FZF only as previewer and lister, call `rg` internally every time query is changed
command! -nargs=* -bang LiveGrep call th3f0x#fzf#live_grep(<q-args>, <bang>0)

command -bang QFList call fzf#run(fzf#wrap('QFList', {
            \   'source': map(getqflist(), 'join([bufname(v:val.bufnr), v:val.lnum, v:val.col, v:val.text], ":")'),
            \   'sink*': function('th3f0x#fzf#build_quickfix_qf'),
            \   'options': fzf#vim#with_preview({
            \       'options': ['--expect=ctrl-t,ctrl-v,ctrl-x', '--ansi', '--multi', '--prompt', "QFList❯ ", "--delimiter", ':', '--preview-window', "+{2}-/2"]
            \}).options,
            \}, <bang>0))


command! -bang -nargs=? -complete=dir FindFiles call th3f0x#fzf#find_files_ff(<q-args>, <bang>0)

command! -bang -nargs=* Grep call fzf#vim#grep(
            \ "grep --recursive -i --line-number --perl-regexp --color=always -- " . shellescape(<q-args>),
            \ 1,
            \ fzf#vim#with_preview({'options': ['--prompt', "Grep❯ "]}),
            \ <bang>0)

command! -bang FzfMan call th3f0x#fzf#fzf_man_pages(<bang>0)

" }}}

" Keymaps:{{{

nnoremap <silent> <C-p> <cmd>Files<CR>

" Dotfiles Search
nnoremap <Leader>fd <cmd>Files ~/dotfiles<CR>

" Find Files respecting vcs settings
nnoremap <Leader>ff <cmd>FindFiles<CR>

nnoremap <Leader>gf <cmd>GFiles<CR>

" Search for word under cursor
nnoremap <silent> <Leader>fw <cmd> call th3f0x#fzf#grep_files(expand("<cword>"))<CR>
nnoremap <silent> <Leader>fW <cmd> call th3f0x#fzf#grep_files(expand("<cWORD>"))<CR>

" Custom LiveGrep
nnoremap <Leader>fg <cmd>LiveGrep<CR>

" Use input function and custom prompt instead of what regular `:Rg` does
nnoremap <Leader>fs <cmd>call th3f0x#fzf#grep_files(input("Search For> "))<CR>

" For help-menu entries
nnoremap <Leader>ht <cmd>Helptags<CR>

" Custom For QuickFix List
nnoremap <Leader>qf <cmd>QFList<CR>

nnoremap <Leader>bl <cmd>BLines<CR>

nnoremap <Leader>bb <cmd>Buffers<CR>

nnoremap <silent> <Leader>fm <cmd>FzfMan<CR>

" }}}

lua << EOF

vim.ui.select = require("7h3f0x.fzf_helpers").vim_ui_select

EOF


" vim:foldmethod=marker

