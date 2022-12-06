augroup non_plugin
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
    " Restore cursor back to blinking, I-beam mode on exit
    autocmd VimLeave * set guicursor=a:ver25-blinkon175
    autocmd BufWritePre * call th3f0x#autocmds#clean_whitespace()
    autocmd ColorScheme * call th3f0x#autocmds#highlights()
    autocmd ColorScheme default call th3f0x#highlights#default()
    autocmd ColorScheme tokyonight* lua require("7h3f0x.tokyonight").on_colorscheme()
    autocmd ColorScheme darkplus call th3f0x#highlights#darkplus()
augroup END

" Differentiate current split with other splits, based on background color
augroup ActiveWin
    autocmd!
    autocmd WinEnter * setlocal winhl=
    autocmd WinLeave * setlocal winhl=Normal:InactiveNormal
augroup END

if getenv("IS_WSL")
    augroup WinClip
        autocmd!
        " Yank to Windows Clipboard when needed(using the <leader>y mapping
        autocmd TextYankPost * silent! call th3f0x#wsl#yankWinClip()
    augroup end
endif
