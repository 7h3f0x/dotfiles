if not pcall(require, 'lsp-status') then
    return
end

local lsp_status = require("lsp-status")

for key, val in pairs(require("7h3f0x.lsp-status.extensions.pyls_ms")) do
    lsp_status.extensions.pyls_ms[key] = val
end

lsp_status.register_progress()

local function select_symbol(cursor_pos, symbol)
    if symbol.valueRange then
        local value_range = {
            ["start"] = {
                character = 0,
                line = vim.fn.byte2line(symbol.valueRange[1])
            },
            ["end"] = {
                character = 0,
                line = vim.fn.byte2line(symbol.valueRange[2])
            }
        }
        return require("lsp-status.util").in_range(cursor_pos, value_range)
    end
end

local config = {
    select_symbol = select_symbol,
    -- the default icon causes some issues with rendering of rest of content
    -- mostly the spinner showing twice and some missing whitespaces
    status_symbol = ' ',
    diagnostics = false,
    show_filename = false,
    component_separator = ''
}

--- @module "lspkind"
local has_lspkind, lspkind = pcall(require, "lspkind")
if has_lspkind then
    config.kind_labels = lspkind.symbol_map
end

lsp_status.config(config)

