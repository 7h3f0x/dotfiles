package.loaded['7h3f0x.telescope'] = nil

local telescope = require("telescope")
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")

local keymap = require("7h3f0x.keymap")
local nnoremap = keymap.nnoremap

local M = {}

function M.find_files(opts)
    builtin.find_files(vim.tbl_extend("force", {
        hidden = true,
        no_ignore = true,
    }, opts or {}))
end

function M.find_dotfiles()
    M.find_files({
        prompt_title = "Dotfiles",
        cwd = "~/dotfiles",
    })
end

function M.find_personal()
    M.find_files({
        prompt_title = "Personal",
        cwd = "~/personal",
    })
end

function M.find_runtime()
    local runtime_dirs = vim.api.nvim_get_runtime_file("", true)
    builtin.find_files(themes.get_ivy({
        path_display = { "truncate" },
        search_dirs = runtime_dirs,
    }))
end

local function setup()
    telescope.setup({
        defaults = {
            layout_config = {
                width = 0.95,
            },
        },
    })
    telescope.load_extension('fzf')
    telescope.load_extension("ui-select")
    if packer_plugins and packer_plugins["nvim-notify"] and packer_plugins["nvim-notify"].loaded then
        telescope.load_extension("notify")
    end
end

local function setup_keymaps()
    nnoremap('<C-p>', '<Cmd>lua require("7h3f0x.telescope").find_files()<CR>')
    nnoremap('<leader>ff', '<Cmd>lua require("telescope.builtin").find_files()<CR>')
    nnoremap('<leader>fd', '<Cmd>lua require("7h3f0x.telescope").find_dotfiles()<CR>')
    nnoremap('<leader>fp', '<Cmd>lua require("7h3f0x.telescope").find_personal()<CR>')
    nnoremap('<leader>fr', '<Cmd>lua require("7h3f0x.telescope").find_runtime()<CR>')
    nnoremap('<leader>ht', '<Cmd>lua require("telescope.builtin").help_tags()<CR>')
end

function M.setup()
    setup()
    setup_keymaps()
end

return M
