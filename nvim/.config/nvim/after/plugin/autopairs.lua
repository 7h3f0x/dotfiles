--- @module 'nvim-autopairs'
local ok, autopairs = pcall(require, "nvim-autopairs")

if not ok then
    return
end

autopairs.setup({
    -- only do auto-pairs thing if next char is a 'space character'
    -- or end of a pair combo
    ignored_next_char = "[^%)%}%]%>%,%s]",
    -- ignored_next_char = "%S",
    disable_in_macro = true,
})

function _ToggleAutoPairs()
    if autopairs.state.disabled then
        print("Enabling autopairs")
        autopairs.enable()
    else
        print("Disabling autopairs")
        autopairs.disable()
    end
end

vim.api.nvim_set_keymap('n', '<M-p>', '<cmd>lua _ToggleAutoPairs()<CR>', { noremap = true })

