
if not pcall(require, "indent_blankline") then
    return
end

local context_patterns = {
    'class', 'function', 'method', '^for',
    '^if', '^else', '^while', '^with',
    'dictionary', '^struct', '^do', '^switch',
    '^case', '^table', '^call', '^constructor',
    '_list$', '^try'
}

-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
vim.opt.colorcolumn:append("99999")

vim.cmd [[
    highlight! IndentBlanklineSpaceIndent1 ctermbg=none guibg=none gui=nocombine
]]

require("indent_blankline").setup({
    -- Good char for showing indent lines
    char = '▏',
    context_char = '▏',
    -- Highlight current indent group, using TreeSitter
    show_current_context = true,
    show_current_context_start = true,
    show_current_context_start_on_current_line = false,
    -- TreeSitter capture groups to use for highlighting current context
    context_patterns = context_patterns,
    buftype_exclude = {
        'terminal', 'nofile'
    },
    filetype_exclude = {
        'help', 'lspinfo', 'man'
    },
    show_trailing_blankline_indent = false,
    space_char_highlight_list = { 'IndentBlanklineSpaceIndent1' },
    space_char_blankline = " "
})

