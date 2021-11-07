
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

    lsp_status.on_attach(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

if pcall(require, 'compe') then
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    }
end

if has_lsp_status then
    capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities)
end

local lang_servers = {
    "pyls_ms", "clangd", "rust_analyzer", "tsserver", "gopls", "cmake", "vimls", "bashls", "sumneko_lua",  "jdtls"
}

if vim.tbl_contains(lang_servers, "pyls_ms") then
    require("7h3f0x.pyls_ms_config")
end

local force_cwd_candidates = { "pyls_ms", "jdtls" }

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

-- Microsoft-pyls setup

config_overrides.pyls_ms = {
    cmd = { "Microsoft.Python.LanguageServer" },
    before_init = function(params, _config)
        local prog = vim.g.python_prog
        if prog then
            params.initializationOptions.interpreter.properties = {
                InterpreterPath = prog.path;
                Version = prog.version;
            }
        else
            -- Use python3 if no virtualenv or if I am in my `ctf` folder,
            -- else use whatever is selected by default
            if os.getenv("VIRTUAL_ENV") == nil and
                vim.loop.cwd():find(os.getenv('HOME') .. '/ctf') == nil then
                params.initializationOptions.interpreter.properties = {
                    InterpreterPath = "/usr/bin/python3";
                    Version = "3.8";
                }
            end
        end
    end,
    commands = {
        PythonSelectInterpreter = {
            function()
                local prompt =  "Select Python Interpreter: "
                local paths = { "/usr/bin/python", "/usr/bin/python3" };
                local p =  vim.fn.exepath('python');
                if not vim.tbl_contains(paths, p) then
                    table.insert(paths, p)
                end

                table.insert(paths, "Default")

                vim.ui.select(paths, { prompt = prompt }, function (item, idx)
                    if not item then
                        return
                    end
                    if item == "Default" then
                        vim.g.python_prog = nil
                    else
                        vim.g.python_prog = {
                            path = paths[idx],
                            version = vim.fn.system({
                                paths[idx],
                                '-c',
                                'import platform;print(platform.python_version())'
                            })
                        }
                    end
                    vim.cmd([[LspRestart]])
                end)
            end,
            description = 'Select Python Interpreter',
        }
    }
}

if has_lsp_status then
    config_overrides.pyls_ms.settings = vim.tbl_deep_extend(
        "keep",
        config_overrides.pyls_ms.settings or {},
        { settings = { python = { workspaceSymbols = { enabled = true }}} }
    )
    config_overrides.pyls_ms.handlers = vim.tbl_extend(
        "keep",
        config_overrides.pyls_ms.handlers or {},
        lsp_status.extensions.pyls_ms.setup()
    )
end

-- Sumneko Lua LS

local sumneko_root_path = os.getenv("HOME") .. '/tools/lua-language-server'
local sumneko_binary = sumneko_root_path .. "/bin/Linux/lua-language-server"

local package_path = vim.split(package.path, ';')
table.insert(package_path, "lua/?.lua")
table.insert(package_path, "lua/?/init.lua")

local lua_runtime = {};
for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
    local lua_path = path .. "/lua";
    if vim.fn.isdirectory(lua_path) then
        lua_runtime[lua_path] = true
    end
end

-- This loads the `lua` files from nvim into the runtime.
lua_runtime[vim.fn.expand("$VIMRUNTIME/lua")] = true
lua_runtime[vim.fn.expand("$VIMRUNTIME/lua/vim")] = true
lua_runtime[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
lua_runtime[vim.fn.expand("$VIMRUNTIME/lua/vim/treesitter")] = true

lua_runtime[vim.fn.expand("~/tools/neovim/src/nvim/lua")] = true
lua_runtime[vim.fn.expand("~/tools/neovim/src/cjson/")] = true


config_overrides.sumneko_lua = {
    cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = package_path,
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
                library = lua_runtime,
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
    if vim.tbl_contains(force_cwd_candidates, name) then
        root_dir = vim.loop.cwd
    else
        root_dir = function(fname)
            return lsp_config[name].document_config.default_config.root_dir(fname) or vim.loop.cwd()
        end
    end
    lsp_config[name].setup(
        vim.tbl_deep_extend("force", {
            root_dir = root_dir,
            on_attach = on_attach,
            capabilities = capabilities,
        }, config_overrides[name] or {})
    )
end

