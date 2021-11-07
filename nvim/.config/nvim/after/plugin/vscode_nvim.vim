if exists("g:vscode")

    let mapleader="\\"

    nnoremap <Leader>n <cmd>nohlsearch<CR>
    vnoremap <BS> "_d

    " For commenting
    xmap gc  <Plug>VSCodeCommentary
    nmap gc  <Plug>VSCodeCommentary
    omap gc  <Plug>VSCodeCommentary
    nmap gcc <Plug>VSCodeCommentaryLine

    " VSCode Specific functions to LSP-Like mappings
    nnoremap <silent> <Leader>rr <cmd>call VSCodeNotify('editor.action.rename')<CR>
    nnoremap <silent> <Leader>gd <cmd>call VSCodeNotify('editor.action.revealDefinition')<CR>
    nnoremap <silent> K          <cmd>call VSCodeNotify('editor.action.showHover')<CR>
    nnoremap <silent> <Leader>rn <cmd>call VSCodeNotify('settings.cycle.relativeLineNumbers')<CR>
endif
