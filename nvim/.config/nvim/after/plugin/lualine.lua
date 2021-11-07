
if not pcall(require, "lualine") then
    return
end

local function whitespace()
    local res = vim.fn.search("\\s$", "nw", 0, 500)
    if res == 0 then
        return ''
    end
    return string.format("[%d]: Trailing Whitespace", res)
end

local function mixed_indent()
    local res = vim.fn.search('\\v(^\\t+ +)|(^ +\\t+)', 'nw', 0, 500)
    if res == 0 then
        return ''
    end
    return string.format("[%d]: Mixed-Indent-Line", res)
end

local function mixed_indent_file()
    local tabs = vim.fn.search('\\v(^\\t+)', 'nw', 0, 500)
    local spaces = vim.fn.search('\\v(^ +)', 'nw', 0, 500)
    if tabs > 0 and spaces > 0 then
        return string.format("[%d:%d] Mixed-Indent-File", tabs, spaces)
    end
    return ''
end

local function checks()
    local v = whitespace() .. mixed_indent() .. mixed_indent_file()

    if vim.api.nvim_win_get_width(0) < 120 and v:len() > 9 then
        return v:sub(1, 9) .. "..."
    end
    return v
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

local function section_x_helper()
    local width = vim.api.nvim_win_get_width(0)
    return width >= vim.o.columns * (3 / 5) and width > 90
end

local lualine = require("lualine")

local custom_onedark = require('lualine.themes/onedark')

custom_onedark.inactive.a.bg = '#3e4452'
custom_onedark.inactive.b.bg = '#3e4452'
custom_onedark.inactive.c.bg = '#3e4452'

custom_onedark.inactive.a.fg = '#abb2bf'
custom_onedark.inactive.b.fg = '#abb2bf'
custom_onedark.inactive.c.fg = '#abb2bf'

-- vim.g.lualine_nothing = " "

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

lualine.setup({
    options = {
        theme = custom_onedark,
        -- section_separators = '',
        -- component_separators = '│'
    },
    sections = {
        -- lualine_a = {
        --     { 'filetype', separator = '', },
        --     { 'g:lualine_nothing', padding = { right = 0 } },
        -- },
        lualine_b = {'branch'},
        lualine_c = {
            {
                'filename',
                shorting_target = 50,
                path = 1
            },
            {
                "diagnostics",
                sources = { "nvim_lsp" },
                update_in_insert = false
            },
        },
        lualine_x = {
            {
                get_curr_status,
                padding = 0,
                -- cond = function() return vim.api.nvim_win_get_width(0) > 110 end
            },
            { 'encoding', cond = section_x_helper },
            { 'fileformat', cond = section_x_helper },
        },
    lualine_y = { 'filetype' }
    -- lualine_y = { { checks, cond = function() return (vim.bo.filetype ~= "help" and not vim.startswith(vim.fn.mode(), 'i')) end } }
    },
    extensions = {
        "fugitive",
        "fzf",
        "quickfix",
        netrw_extension
    },
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
})

