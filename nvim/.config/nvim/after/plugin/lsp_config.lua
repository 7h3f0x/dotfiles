
if not pcall(require, "lspconfig") then
    return
end

local lsp_config = require("lspconfig")

local my_lsp = require("7h3f0x.lsp")

my_lsp.diagnostic_setup()

my_lsp.hover_setup()

--- @module "lspkind"
local has_lspkind, lspkind = pcall(require, "lspkind")
if has_lspkind then
    lspkind.init({symbol_map = {Method = ''}})
end

--- @module 'lsp-status'
local has_lsp_status, lsp_status = pcall(require, "lsp-status")

local function on_attach(client, bufnr)
    my_lsp.signature_attach(bufnr)
    my_lsp.keymaps_attach(bufnr)
    my_lsp.options_attach(client, bufnr)
    my_lsp.document_highlight_attach(client)

    if has_lsp_status then
        lsp_status.on_attach(client)
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local has_cmp, _ = pcall(require, "cmp")
--- @module 'cmp_nvim_lsp'
local has_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if has_cmp and has_cmp_lsp then
    capabilities = cmp_lsp.update_capabilities(capabilities)
end

if has_lsp_status then
    capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)
end

local lang_servers = {
    "pyright", "clangd", "rust_analyzer", "tsserver", "gopls", "cmake", "vimls", "bashls", "sumneko_lua",  "jdtls"
}

local force_cwd_candidates = { "jdtls", "tsserver" }

local config_overrides = {}

config_overrides.clangd = {
    cmd = { "clangd", "--background-index", "--fallback-style=none", "--clang-tidy" },
}

if has_lsp_status then
    config_overrides.clangd.init_options = vim.tbl_extend(
        "keep",
        config_overrides.clangd.init_options or {},
        { clangdFileStatus = true }
    )
    config_overrides.clangd.handlers = vim.tbl_extend(
        "keep",
        config_overrides.clangd.handlers or {},
        lsp_status.extensions.clangd.setup()
    )
end

-- Sumneko Lua LS

local package_path = vim.split(package.path, ';')
table.insert(package_path, "lua/?.lua")
table.insert(package_path, "lua/?/init.lua")

config_overrides.sumneko_lua = {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = package_path,
                -- do not apply path pattern for subdirectories
                pathStrict = true,
            },
            completion = {
                callSnippet = "Replace"
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                -- nvim below 0.6 returns nothing if given `""`
                library = vim.api.nvim_get_runtime_file("/", true),
                maxPreload = 10000,
                preloadFileSize = 10000,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

-- JDT-LS

vim.fn.setenv("JDTLS_HOME", os.getenv("HOME") .. '/tools/jdt.ls')
vim.fn.setenv("JAVA_HOME", "/usr/lib/jvm/java-11-openjdk-amd64")
vim.fn.setenv("WORKSPACE", os.getenv("HOME") .. "/.local/share/jdt-ls")

config_overrides.jdtls = {
    settings = {
        java = {
            signatureHelp = {
                enabled = true
            },
            contentProvider = {
                preferred = 'fernflower'
            }
        }
    }
}

for _, name in ipairs(lang_servers) do
    local root_dir = nil
    local default_config = lsp_config[name].document_config.default_config
    if vim.tbl_contains(force_cwd_candidates, name) then
        root_dir = vim.loop.cwd
    else
        root_dir = function(fname)
            -- nvim 0.5.1 onwards allows root_dir to be nil
            if vim.fn.has("nvim-0.5.1") == 0 then
                return default_config.root_dir(fname) or vim.loop.cwd()
            else
                return default_config.root_dir(fname)
            end
        end
    end

    local handler_compat = require("7h3f0x.lsp").handler_compat
    local handlers = {}
    for k, v in pairs(default_config.handler_compat or {}) do
        handlers[k] = handler_compat(v)
    end

    lsp_config[name].setup(
        vim.tbl_deep_extend("force", {
            root_dir = root_dir,
            on_attach = on_attach,
            capabilities = capabilities,
            handlers = handlers,
        }, config_overrides[name] or {})
    )
end

