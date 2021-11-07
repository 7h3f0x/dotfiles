
package.loaded["7h3f0x.lsp_custom_wrappers"] = nil

local M = {}

vim.cmd([[
    highlight! def RenameSign guifg=#98be65 ctermfg=lightgreen
]])

vim.fn.sign_define("rename_prefix", {
    text =  "➤ ",
    texthl = "RenameSign"
})

function M.rename()
    if #vim.lsp.buf_get_clients(0) == 0 then
        vim.api.nvim_err_writeln("No lsp clients attached to current buffer")
        return
    end
    local word = vim.fn.expand("<cword>")

    local buf_id = vim.api.nvim_create_buf(false, true)
    -- vim.api.nvim_buf_set_option(buf_id, 'modifiable', true)
    vim.api.nvim_buf_set_option(buf_id, 'bufhidden', 'wipe')


    local win_id = vim.api.nvim_open_win(buf_id, true, {
        relative = "cursor",
        height = 1,
        width = math.ceil(vim.o.columns * 0.3) + 2,
        row = 1,
        col = 1,
        style = "minimal",
        border = "rounded"
    })

    vim.api.nvim_win_set_option(win_id, 'winhl', "NormalFloat:BlackFloat,FloatBorder:BlackFloatBorder")
    vim.api.nvim_win_set_option(win_id,'wrap', false)
    vim.api.nvim_win_set_option(win_id,'signcolumn', "yes")

    vim.fn.sign_place(0, "", "rename_prefix", buf_id, { lnum = 1 })

    vim.api.nvim_win_call(win_id, function()
        vim.api.nvim_command("norm! i" .. word)
    end)
    vim.api.nvim_win_call(win_id, function()
        vim.api.nvim_command("norm! viw")
    end)

    vim.api.nvim_buf_call(buf_id, function()
        vim.api.nvim_command(
            string.format(
                "autocmd WinLeave <buffer> call nvim_buf_delete(%d, { 'force' : v:true })",
                buf_id
            )
        )
    end)

    vim.api.nvim_buf_set_keymap(
        buf_id,
        "i",
        "<CR>",
        string.format("<Esc><cmd>lua require('7h3f0x.lsp_custom_wrappers')._rename(%d, %d)<CR>", win_id, buf_id),
        { noremap = true, silent = true }
    )

    vim.api.nvim_buf_set_keymap(
        buf_id,
        "n",
        "<CR>",
        string.format("<cmd>lua require('7h3f0x.lsp_custom_wrappers')._rename(%d, %d)<CR>", win_id, buf_id),
        { noremap = true, silent = true }
    )


end

function M._rename(win_id, buf_id)
    local text = vim.api.nvim_buf_get_lines(buf_id, 0, 1, false)[1]
    vim.api.nvim_win_close(win_id, true)
    if text:len() > 0 then
        vim.lsp.buf.rename(text)
    end
end

return M

