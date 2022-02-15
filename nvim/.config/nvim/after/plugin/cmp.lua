--- @module 'cmp'
local has_cmp, cmp = pcall(require, "cmp")
if not has_cmp then
    return
end

--- @module "lspkind"
local has_lspkind, lspkind = pcall(require, "lspkind")

--- @module "luasnip"
local has_luasnip, luasnip = pcall(require, "luasnip")

-- Options:

vim.opt.shortmess:append("c")
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }

-- Setup:

cmp.setup({
    PreselectMode = cmp.PreselectMode.None,

    documentation = {
        border = "rounded",
        max_width = 120,
        min_width = 30,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1,
    },

    snippet = {
        expand = function(args)
            if has_luasnip then
               luasnip.lsp_expand(args.body)
            end
        end
    },

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
    }),

    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
        }),
    },


    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                buffer = "[Buffer]",
                luasnip = "[LuaSnip]",
            })[entry.source.name]

            if has_lspkind then
                return lspkind.cmp_format()(entry, vim_item)
            else
                return vim_item
            end
        end,
    },

    experimental = {
        native_menu = false,
        ghost_text = false,
    },
})

cmp.setup.cmdline('/', {
    completion = {
        autocomplete = false,
    },

    sources = {
        { name = 'buffer' },
    },
})

