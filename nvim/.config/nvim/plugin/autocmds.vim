
augroup non_plugin
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
    " Restore cursor back to blinking, I-beam mode on exit
    autocmd VimLeave * set guicursor=a:ver25-blinkon175
    autocmd BufWritePre * call th3f0x#autocmds#clean_whitespace()
augroup END

