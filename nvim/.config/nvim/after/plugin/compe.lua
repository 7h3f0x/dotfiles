
if not pcall(require, 'compe') then
    return
end

--- @module "lspkind"
local has_lspkind, lspkind = pcall(require, "lspkind")
local buf_kind = "Text"
if has_lspkind then
    buf_kind = lspkind.symbolic(buf_kind)
end

-- Setup:

require("compe").setup({
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'disable';
    throttle_time = 80;
    source_timeout = 200;
    resolve_timeout = 800;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = {
        border = "rounded",
        max_width = 120,
        min_width = 30,
        max_height = math.floor(vim.o.lines * 0.3),
        min_height = 1,
    };

    source = {
        path = true;
        buffer = {
            kind = buf_kind
        };
        calc = true;
        nvim_lsp = true;
        nvim_lua = true;
        vsnip = false;
        ultisnips = false;
        luasnip = true;
    };
})

-- Options:

vim.opt.shortmess:append("c")
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }


-- Keymaps:

local function inoremap(lhs, rhs, opts)
    opts = vim.tbl_extend("force", {
            noremap = true,
            expr = true,
            silent = true
    }, opts or {})
    vim.api.nvim_set_keymap('i', lhs, rhs, opts)
end

-- Force compe-completion
inoremap('<C-Space>', "compe#complete()")

inoremap("<C-e>", "compe#close('<C-e>')")
inoremap("<C-b>", "compe#scroll({ 'delta': +4 })")
inoremap("<C-f>", "compe#scroll({ 'delta': -4 })")

if pcall(require, "nvim-autopairs") then
    inoremap("<CR>", 'compe#confirm(luaeval("require \'nvim-autopairs\'.autopairs_cr()"))')
else
    inoremap("<CR>", 'compe#confirm("\\<CR>")')
end

