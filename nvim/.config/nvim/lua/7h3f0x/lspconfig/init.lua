local lspconfig = require("lspconfig")

local M = {}

local servers = {
    "clangd",
    "pyright",
    "sumneko_lua",
}

local has_lsp_status, lsp_status = pcall(require, "lsp-status")

function M.on_attach(client, bufnr)

    if has_lsp_status then
        lsp_status.on_attach(client)
    end

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = {
        noremap = true,
        silent = true,
    }

    local function map(lhs, rhs, mode)
        mode = mode or 'n'
        vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
    end

    local mappings = {
        gd = '<cmd>lua vim.lsp.buf.definition()<CR>',
        K = '<cmd>lua vim.lsp.buf.hover()<CR>',
        gr = '<Cmd>lua require("telescope.builtin").lsp_references()<CR>',
        ["<leader>gr"] = '<cmd>lua vim.lsp.buf.references()<CR>',
        ["<leader>K"] = 'K',
        ["<leader>rr"] = '<cmd>lua vim.lsp.buf.rename()<CR>',
        ["<leader>ca"] = '<cmd>lua vim.lsp.buf.code_action()<CR>',
        ["[d"] = '<cmd>lua vim.diagnostic.goto_prev()<CR>',
        ["]d"] = '<cmd>lua vim.diagnostic.goto_next()<CR>',
        gl = '<cmd>lua vim.diagnostic.open_float(0, {scope = "line"})<CR>',
     }

    for key, action in pairs(mappings) do
        map(key, action)
    end

    map("<M-k>", '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'i')

    if client.server_capabilities.documentFormattingProvider then
        vim.cmd([[command! -buffer LspFormat lua vim.lsp.buf.formatting()]])
    end

    if client.server_capabilities.documentRangeFormattingProvider then
        vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
    end

    if client.server_capabilities.documentHighlightProvider then
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

function M.setup()
    vim.diagnostic.config({
        virtual_text = {
            source = "always",
            spacing = 8,
        },
        float = {
            border = "rounded"
        }
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
            border = "rounded",
        }
    )

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
            border = "rounded",
        }
    )

    for _, lsp in pairs(servers) do
        local has_config, config = pcall(require, "7h3f0x.lspconfig." .. lsp)
        if not has_config then
            config = {}
        end
        lspconfig[lsp].setup(vim.tbl_extend("force", {
            on_attach = M.on_attach,
            flags = {
                -- This will be the default in neovim 0.7+
                debounce_text_changes = 150,
            }
        }, config))
    end
end

return M
