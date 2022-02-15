function! th3f0x#highlights#highlight_onedark() abort
    highlight TablineSel guibg=#98c379 guifg=#282c34

    highlight! link vimFunction Function
    highlight! link vimUserFunc Function
    highlight! link vimUsrCmd Identifier

    highlight! link LspSignatureActiveParameter IncSearch
    highlight! link Keyword Statement
    highlight! link TSInclude Statement
    highlight! TSVariable ctermfg=145 guifg=#ABB2BF
    highlight! TSStringEscape ctermfg=39 guifg=#61AFEF
    highlight! TSVariableBuiltin ctermfg=215 guifg=#FFAF5F

    highlight def LspReferenceText gui=underline cterm=underline ctermbg=236 guibg=#373b41
    highlight def link LspReferenceRead LspReferenceText
    highlight def link LspReferenceWrite LspReferenceText

    " Highlighting the underline on gui using only underline color, not color
    " whole foreground. also undercurl is better
    highlight DiagnosticUnderlineError    gui=undercurl guifg=none guisp=#E06c75
    highlight DiagnosticUnderlineWarn     gui=undercurl guifg=none guisp=#E5C07B
    highlight DiagnosticUnderlineInfo     gui=undercurl guifg=none guisp=#61AFEF
    highlight DiagnosticUnderlineHint     gui=undercurl guifg=none guisp=#56B6C2

    if !has('nvim-0.6')
        highlight! link LspDiagnosticsUnderlineHint          DiagnosticUnderlineHint
        highlight! link LspDiagnosticsUnderlineError         DiagnosticUnderlineError
        highlight! link LspDiagnosticsUnderlineWarning       DiagnosticUnderlineWarn
        highlight! link LspDiagnosticsUnderlineInformation   DiagnosticUnderlineInfo
    endif

    highlight! link FloatBorder NormalFloat

    " Bash specific TreeSitter Highlighting
    highlight link bashTSVariable     shShellVariables
    highlight link bashTSPunctSpecial shShellVariables

    highlight! bashTSOption ctermfg=145 guifg=#ABB2BF
    highlight IndentBlanklineChar ctermfg=59 guifg=#5C6370

    highlight Comment gui=NONE
    highlight InactiveWin guibg=#2c323d ctermbg=238

    highlight! link CmpItemMenu type
    highlight! CmpItemAbbrMatch      ctermfg=215 guifg=#FFAF5F gui=bold cterm=bold
    highlight! CmpItemAbbrMatchFuzzy ctermfg=215 guifg=#FFAF5F gui=bold cterm=bold

endfunction

