
package.loaded['7h3f0x.lsp'] = nil

local M = {}

local opts = {
    noremap = true,
    silent = true
}

--- @module 'lsp_signature'
local has_lsp_signature, lsp_signature = pcall(require, "lsp_signature")

if not has_lsp_signature then
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
            border = "rounded",
            max_height = 4,
            max_width = 80,
        }
    )
end

function M.signature_attach(bufnr)
    if has_lsp_signature then
        lsp_signature.on_attach({
            bind = true,
            handler_opts = {
                border = "rounded"
            },
            doc_lines = 2,
            floating_window_above_cur_line = true,
            hi_parameter = "IncSearch",
            zindex = 50,
            toggle_key = '<M-k>'
        }, bufnr)
    else
        vim.api.nvim_buf_set_keymap(bufnr, 'i', '<M-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    end
end

function M.keymaps_attach(bufnr)
    local function map(lhs, rhs, options)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', lhs, rhs, options)
    end

    map('K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    map('<Leader>K', 'K', opts)
    map('<Leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    map('<Leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    map('<Leader>gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    map('<Leader>dh', '<cmd>lua vim.lsp.buf.document_highlight()<CR>', opts)
    map('<Leader>cr', '<cmd>lua vim.lsp.buf.clear_references()<CR>', opts)

    map('<Leader>bf', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    map('<Leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'x', '<Leader>ca', ':lua vim.lsp.buf.range_code_action()<CR>', opts)


    if vim.fn.has("nvim-0.6") ~= 0 then
        map('<Leader>dl', '<cmd>lua vim.diagnostic.open_float(0, {scope = "line"})<CR>', opts)
        map('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
        map(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    else
        map('<Leader>dl', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics({border = "rounded"})<CR>', opts)
        map('[d', '<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = "rounded"}})<CR>', opts)
        map(']d', '<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = "rounded"}})<CR>', opts)
    end

    map('<Leader>rr', '<cmd>lua require("7h3f0x.lsp_custom_wrappers").rename()<CR>', opts)

    if vim.g.loaded_fzf_vim == 1 then
        map('<Leader>fr', '<cmd>lua require("7h3f0x.fzf-lsp").references()<CR>', opts)
        map('<Leader>ds', '<cmd>lua require("7h3f0x.fzf-lsp").document_symbols()<CR>', opts)
    end

end

function M.document_highlight_attach(client)
    if client.resolved_capabilities.document_highlight then
        vim.cmd([[
            augroup DocumentHighlight
                autocmd! * <buffer>
                autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]])
    end
end

function M.options_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    if client.resolved_capabilities.document_range_formatting and vim.lsp.formatexpr then
        vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
    end
end

function M.diagnostic_setup()
    if vim.fn.has("nvim-0.6") ~= 0 then
        vim.diagnostic.config({
            virtual_text = {
                source = "always",
                spacing = 8,
            },
            float = {
                border = "rounded"
            }
        })
    else
        local on_publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
         vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            on_publish_diagnostics, {
                virtual_text = {
                    -- more space
                    spacing = 8,
                },
            }
        )
    end
end

function M.hover_window_size_update()
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
            border = "rounded",
            max_width = math.ceil(vim.o.columns * 0.7),
            max_height = math.ceil(vim.o.lines * 0.3)
        }
    )
end

function M.hover_setup()
    M.hover_window_size_update()

    vim.cmd([[
        augroup hover_resize
        autocmd!
        autocmd VimResized * lua require("7h3f0x.lsp").hover_window_size_update()
        augroup END
    ]])

end

-- allow new handler signature to be used with nvim-0.5 (older signature)
function M.handler_compat(f)
    if vim.fn.has("nvim-0.5.1") ~= 0 then
        return f
    end
    return function(err, method, result, client_id, bufnr, config)
        local ctx = {
            method = method,
            client_id = client_id,
            bufnr = bufnr
        }
        return f(err, result, ctx, config)
    end
end


return M

