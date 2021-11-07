--- @module 'nvim-autopairs'
local ok, autopairs = pcall(require, "nvim-autopairs")

if not ok then
    return
end

autopairs.setup({})

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

