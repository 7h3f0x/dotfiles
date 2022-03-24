
if not pcall(require, "lualine") then
    return
end

local function get_treesitter_status()
    if pcall(require, "nvim-treesitter") then
        local line = require("nvim-treesitter").statusline({indicator_size = 60})
        return line or ""
    end
    return ""
end

--- @module 'lsp-status'
local has_lsp_status, lsp_status = pcall(require, "lsp-status")

local function get_curr_status()
    if has_lsp_status then
        if #vim.lsp.buf_get_clients() > 0 then
            return lsp_status.status()
        end
        return ''
    end
    return get_treesitter_status()
end

local lualine = require("lualine")

local custom_onedark = require('lualine.themes/onedark')

custom_onedark.inactive.a.bg = '#3e4452'
custom_onedark.inactive.b.bg = '#3e4452'
custom_onedark.inactive.c.bg = '#3e4452'

custom_onedark.inactive.a.fg = '#abb2bf'
custom_onedark.inactive.b.fg = '#abb2bf'
custom_onedark.inactive.c.fg = '#abb2bf'

vim.opt.showmode = false

local netrw_extension = {
    sections = {
        lualine_a = { 'mode' },
        lualine_c = {
            { 'filename', shorting_target = 0, path = 1 }
        }
    },
    inactive_sections = {
        lualine_c = {
            { 'filename', shorting_target = 0, path = 1 }
        }
    },
    filetypes = {
        'netrw'
    }
}

local tabline = nil

if vim.fn.has("nvim-0.6") ~= 0 then
   tabline = {
        lualine_a = {
            {
                'tabs',
                mode = 2,
                max_length = function()
                    return vim.o.columns
                end,
            },
        }
    }
end

local no_global_statusline = nil
if vim.fn.has("nvim-0.7") == 0 then
    no_global_statusline = true
end

lualine.setup({
    options = {
        theme = custom_onedark
    },
    sections = {
        lualine_b = no_global_statusline and {'branch', 'diagnostics'},
        lualine_c = {
            {
                'filename',
                shorting_target = 50,
                path = 1
            },
        },
        lualine_x = {
            {
                get_curr_status,
                padding = 0,
            },
            'encoding',
            'fileformat',
            'filetype'
        },
    },
    extensions = {
        "fugitive",
        "fzf",
        "quickfix",
        netrw_extension
    },
    tabline = tabline,
})

if not no_global_statusline then
    vim.opt.laststatus = 3
end
