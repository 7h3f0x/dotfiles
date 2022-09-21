local M = {}

local function make_noremap(mode)
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force", {
            noremap = true,
            silent = true,
        }, opts or {})
        vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
    end
end

M.nnoremap = make_noremap('n')
M.inoremap = make_noremap('i')
M.xnoremap = make_noremap('x')

return M
