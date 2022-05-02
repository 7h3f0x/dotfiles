
if not pcall(require, "luasnip") then
    return
end

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

local snippets = {
    c = {
        s({trig = "mainv", name = "mainv",
            dscr = "Standard C main function with no command-line arguments"}, {
            t({"int main(void) {", ""}),
            t("\t"), i(1, "// your code"),
            t({"", "\treturn 0;", "}"})
        }),
        s({trig = "main", name = "main",
            dscr = "Standard C main function with cli args"},
            fmt([[
                int main(int argc, char* argv[]) {{
                    {}
                    return 0;
                }}
            ]], { i(1) })
        ),
        s({trig = "inc", name = "include", dscr = "include a header"},
            fmt('#include <{}>', { i(1) })
        ),
        s({trig = "for", name = "for", dscr = "regular numeric for-loop"},
            fmt([[
                for ({} {} = 0; {i} < {}; ++{i}) {{
                    {}
                }}
            ]], {
                i(1, "int"),
                i(2, "i"),
                i(3, "N"),
                i(4),
                i = rep(2)
            })
        )
    },
    cpp = {
        s({trig = "fori", name = "iterator for loop",
            dscr = "for loop using iterators"},
            fmt([[
                for (auto {} = {}.begin(); {it} != {container}.end(); ++{it}) {{
                    {}
                }}
            ]], {
                i(1, "it"),
                i(2, "container"),
                i(3),
                it = rep(1),
                container = rep(2)
            })
        ),
        s({trig = "cout", name = "cout-endl combo",
            dscr = "cout with respective endl as well"},
            fmt("std::cout << {} << std::endl;", { i(1) })
        )
    },
    lua = {
        s({ trig = "req", name = "require", dscr = "require a module" },
            -- https://github.com/L3MON4D3/LuaSnip/blob/6e10a30178240182781955ce062618c8d793a37b/Examples/snippets.lua#L374
            fmt('require("{}")', { i(1) })
        )
    }
}

for k, v in pairs(snippets) do
    ls.add_snippets(k, v)
end

ls.filetype_extend("cpp", {"c"})

ls.config.set_config({
    updateevents = "TextChanged,TextChangedI",
})

local function map(mode, lhs, rhs)
    vim.api.nvim_set_keymap(mode, lhs, rhs, { expr = true })
end

map('i',"<C-k>", "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-k>'")
map('i',"<C-j>", "luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<C-j>'")
map('s',"<C-k>", "luasnip#jumpable(1)  ? '<Plug>luasnip-jump-next' : '<C-k>'")
map('s',"<C-j>", "luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<C-j>'")

