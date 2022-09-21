local has_packer, packer = pcall(require, "packer")

if not has_packer then
    return
end

-- can load these plugins later, by using `PackerLoad! <name>`
local function load_heavy()
    return vim.v.progname ~= 'vim'
end

vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]])

return packer.startup({ function(use)

    use({
        'wbthomason/packer.nvim',
    })

    use({
        'folke/tokyonight.nvim',
        -- `0` not supported for `nvim_set_hl` in nvim-0.6
        commit = 'a3b558b552a7cc932f92328a5fe053711155e242',
        cond = load_heavy,
        config = function()
            vim.cmd([[colorscheme tokyonight-night]])
            local util = require("tokyonight.util")
            local theme = require("lualine.themes.tokyonight")
            util.highlight('User1', theme.normal.a)
            util.highlight('User2', theme.insert.a)
            util.highlight('User3', theme.visual.a)
            util.highlight('User4', theme.replace.a)
            util.highlight('User5', theme.command.a)
            util.highlight('User6', theme.normal.b)
        end,
    })

    use({
        'nvim-treesitter/nvim-treesitter',
        commit = '21ac88b9551072f49ba994f461f78794af43a5aa',
        cond = load_heavy,
        requires = {
            {
                'nvim-treesitter/nvim-treesitter-context',
                commit = '4938cda68e5a6ca827feed25970f8ad78a580191',
                config = function()
                    require('treesitter-context').setup({})
                end,
            },
        },
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { "c", "lua", "vim", "python" },
                highlight = {
                    enable = true,
                    disable = {
                        "vim",
                    },
                },
            })
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
        end,
    })

    use({
        'neovim/nvim-lspconfig',
        tag = 'v0.1.2',
        cond = load_heavy,
        requires = {
            {
                'j-hui/fidget.nvim',
                config = function()
                    require('fidget').setup({
                        text = {
                            spinner = "dots_negative"
                        }
                    })
                end,
            },
            {
                'nvim-lua/lsp-status.nvim',
                config = function()
                    require("lsp-status").config({
                        select_symbol = function(cursor_pos, symbol)
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
                    end,
                    status_symbol = ' ',
                    diagnostics = true,
                })
                end,
            },
            -- https://github.com/neovim/neovim/issues/12587
            {'antoinemadec/FixCursorHold.nvim'},
        },
        config = function()
            require("7h3f0x.lspconfig").setup()
        end,
    })

    -- Git Integration
    use({
        'tpope/vim-fugitive',
    })

    -- Comment and Uncomment lines
    use({
        'tpope/vim-commentary',
    })

    -- Surround text objects and be able to repeat with `.`
    use({
        'tpope/vim-surround',
    })

    use({
        'tpope/vim-repeat',
    })

    -- View and goto undo history
    use({
        'mbbill/undotree',
        config = function()
            local nnoremap = require("7h3f0x.keymap").nnoremap
            nnoremap('<leader>u', '<Cmd>UndotreeToggle<CR>')
        end,
    })

    use({
        'nvim-telescope/telescope.nvim',
        cond = load_heavy,
        tag = 'nvim-0.6',
        requires = {
            {'nvim-lua/plenary.nvim'},
            {
                'kyazdani42/nvim-web-devicons',
                config = function()
                    require('nvim-web-devicons').setup({})
                end,
            },
            {'nvim-telescope/telescope-fzf-native.nvim', run = 'make'},
            {'nvim-telescope/telescope-ui-select.nvim'}
        },
        config = function()
            require("7h3f0x.telescope").setup()
        end,
    })

    use({
        'rcarriga/nvim-notify',
        config = function()
            vim.notify = require("notify")
        end,
    })

    use({
        'lewis6991/impatient.nvim',
        tag = 'v0.2',
    })

    use({
        'dstein64/vim-startuptime',
        cmd = {'StartupTime'},
    })

end, config = {
        display = {
            open_fn = require('packer.util').float,
        },
    }
})
