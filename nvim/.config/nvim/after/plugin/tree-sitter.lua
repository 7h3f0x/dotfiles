if not pcall(require, 'nvim-treesitter.configs') then
    return
end

require('nvim-treesitter.configs').setup({
    ensure_installed = {
        "vim", "lua", "c", "cpp", "python", "query", "bash", "comment", "regex", "rst"
    },
    highlight = {
        enable = true,
        disable = { "vim" }
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    },
    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = {"BufWrite", "CursorHold"},
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["aC"] = "@class.outer",
                ["iC"] = "@class.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["ac"] = "@conditional.outer",
                ["ic"] = "@conditional.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
            }
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
        lsp_interop = {
            enable = true,
            border = 'none',
            peek_definition_code = {
                ["<Leader>df"] = "@function.outer",
                ["<Leader>dc"] = "@class.outer",
            },
        }
    }
})

local hlmap = vim.treesitter.highlighter.hl_map
hlmap["bash_option"] = "TSOption"

if vim.fn.exists(":TSHighlightCapturesUnderCursor") then
    local function noremap(lhs, rhs)
        vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
    end

    -- View highlight group for text under cursor when using TreeSitter
    noremap("<Leader>hh", "<cmd>TSHighlightCapturesUnderCursor<CR>")
end


require('nvim-treesitter').define_modules({
    my_indent_plugin = {
        enable = true,

        attach = function(_bufnr, _lang)
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
        end,

        detach = function(_bufnr, _lang)
            -- TODO: do something?
        end,

        is_supported = function(_lang)
            -- Check if the language is supported
            return true
        end
    }
})

