
package.loaded['7h3f0x.fzf-lsp'] = nil

local M = {}

local util = vim.lsp.util

local fzf_run = vim.fn["fzf#run"]
local fzf_wrap = vim.fn["fzf#wrap"]
local fzf_with_preview = vim.fn["fzf#vim#with_preview"]

local my_lsp = require("7h3f0x.lsp")

local function result_handler(name, items, opts)
    local res = {}
    for _, v in ipairs(items) do
        table.insert(
            res,
            table.concat({
                vim.fn.fnamemodify(v.filename or vim.fn.bufname(v.filename), ":."),
                v.lnum,
                v.col,
                v.text
            }, ":")
        )
    end

    local saved = vim.g.fzf_preview_window
    local pos = opts.pos or 'down'
    vim.g.fzf_preview_window = { pos .. ':55%', 'ctrl-/' }

    local prompt = name .. "❯ "
    local wrapped = fzf_wrap(name, fzf_with_preview({
            source = res,
            options = vim.tbl_extend("force", {
                '--expect=ctrl-t,ctrl-v,ctrl-x',
                '--multi',
                '--prompt', prompt,
                "--delimiter", ':',
                '--preview-window', "+{2}-/2",
            }, opts.args or {}),
        })
    )

    vim.g.fzf_preview_window = saved

    wrapped.sink = nil
    wrapped["sink*"] = function(results)
        local fname, lnum, col = unpack(vim.split(results[2], ":", false))
        local map = vim.g.fzf_action or {
            ["ctrl-x"] = "split",
            ["ctrl-v"] = "vertical split",
            ["ctrl-t"] = "tabedit",
        }
        local cmd = map[results[1]] or 'edit'
        vim.api.nvim_command(cmd .. ' ' .. fname)
        vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) - 1 })
    end

    fzf_run(wrapped, opts.bang)
end

function M.references(bang)
    bang = bang or 0

    local params = util.make_position_params()
    params.context = {
        includeDeclaration = true;
    }

    vim.lsp.buf_request(
        0,
        'textDocument/references',
        params,
        my_lsp.handler_compat(function(_, result, _ctx, _config)
            if not result or vim.tbl_isempty(result) then
                return
            end

            result_handler(
            "References[LSP]",
            util.locations_to_items(result),
            { bang = bang }
            )
        end)
    )
end

function M.document_symbols(bang)
    bang = bang or 0

    local params = { textDocument = util.make_text_document_params() }

    vim.lsp.buf_request(
        0,
        'textDocument/documentSymbol',
        params,
        my_lsp.handler_compat(function(_, result, ctx, _config)
            local bufnr = ctx.bufnr
            if not result or vim.tbl_isempty(result) then
                return
            end

            result_handler(
            "DocumentSymbols[LSP]",
            util.symbols_to_items(result, bufnr),
            { bang = bang, pos = "right", args = { "--with-nth=4.." } }
            )
        end)

    )

end

return M

