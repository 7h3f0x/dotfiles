
" Custom Commands And Functions:{{{

nnoremap <Leader><Leader> <cmd>call th3f0x#keymaps#save_and_source()<CR>

nnoremap <Leader>t <cmd>lua require("7h3f0x.floatterm").toggle_terminal()<CR>

"}}}

" Vim Remaps:{{{
" View highlight group of text under cursor
map <F10> <cmd>echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Select previously pasted text
nnoremap <Leader>vp `[v`]

nnoremap <silent> <Leader>fe <cmd>20Lexplore<CR>

" might need to disable terminal-emulator's mapping for this to work
nnoremap <M-a> ggVG

" Toggle Relative Numbers
nnoremap <silent> <Leader>rn <cmd>set rnu!<CR>

" Delete buffer, but dont close window
nnoremap <silent> <M-q> <cmd>bp <bar> bd #<CR>

nnoremap <silent> <Leader>n <cmd>nohlsearch<CR>

" Keep replacing with .
nnoremap <silent> <Leader>cw <cmd>call setreg("/", '\<' . expand("<cword>") . '\>')<CR>cgn

" Dont add deleted stuff to a register
xnoremap <BS> "_d
snoremap <silent> <BS> <C-g>"_c

" Copy all search matches in selected area into register a
" https://superuser.com/questions/818290/select-all-matching-text-in-vim
xnoremap <Leader>a :%s//\=setreg('A', submatch(0), 'V')/n
cnoremap <C-a> \=setreg('A', submatch(0), 'V')/n

nnoremap - <cmd>execute "Explore " . expand("%:p:h")<CR>

nnoremap <C-j> <cmd>cnext<CR>zz
nnoremap <C-k> <cmd>cprev<CR>zz

" Move selection of lines up or down
xnoremap <silent> <C-j> :move '>+1<CR>gv
xnoremap <silent> <C-k> :move '<-2<CR>gv

let g:tmux_dir_map = {
            \   'h': 'L',
            \   'l': 'R',
            \   'k': 'U',
            \   'j': 'D'
            \}


" Move around splits in both vim and tmux
for key in keys(g:tmux_dir_map)
    execute printf("nnoremap <M-%s> <cmd>call th3f0x#keymaps#tmux_helper('%s')<CR>", key, key)
    execute printf("tnoremap <M-%s> <cmd>call th3f0x#keymaps#tmux_helper('%s')<CR>", key, key)
endfor

nnoremap <C-Up>    <cmd>resize +1<CR>
nnoremap <C-Down>  <cmd>resize -1<CR>
nnoremap <C-Left>  <cmd>vertical resize -1<CR>
nnoremap <C-Right> <cmd>vertical resize +1<CR>

if !getenv('IS_WSL')
    " If I mention register explicitly (to somthing other than "), copy to that
    " register, else copy to clipboard
    nnoremap <silent><expr> y  v:register == '"' ? '"+y' : 'y'
    nnoremap <silent><expr> Y  v:register == '"' ? '"+y$' : 'y$'
    xnoremap <silent><expr> y  v:register == '"' ? '"+y' : 'y'
else
    nnoremap <leader>y "+y
    xnoremap <leader>y "+y
endif

nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
xnoremap <Leader>p "+p

cnoremap <C-j> <Down>
cnoremap <C-k> <Up>

" }}}

" vim:foldmethod=marker

