
if not pcall(require, "luasnip") then
    return
end

require("luasnip.loaders.from_vscode").lazy_load()

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.snippets = {
    c = {
        s({ trig = "mainv", name = "mainv",
            dscr = "Standard C main function with no command-line arguments"}, {
            t({"int main(void){", ""}),
            t("\t"), i(1, "// your code"),
            t({"", "\treturn 0;", "}"})
        })
    },
}

-- have to do this due to compe
-- should use `ls.filetype_extend("cpp", {"c"})` once I get to cmp
ls.snippets.cpp = ls.snippets.c

local function map(mode, lhs, rhs)
    vim.api.nvim_set_keymap(mode, lhs, rhs, { expr = true })
end

map('i',"<C-k>", "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-k>'")
map('i',"<C-j>", "luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<C-j>'")
map('s',"<C-k>", "luasnip#jumpable(1)  ? '<Plug>luasnip-jump-next' : '<C-k>'")
map('s',"<C-j>", "luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<C-j>'")

