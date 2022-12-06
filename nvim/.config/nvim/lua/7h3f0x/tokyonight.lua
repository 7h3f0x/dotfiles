local M = {}

function M.on_colorscheme()
    if packer_plugins and packer_plugins["tokyonight.nvim"] then
        local util = require("tokyonight.util")
        local theme = require("lualine.themes.tokyonight")
        util.highlight('User1', theme.normal.a)
        util.highlight('User2', theme.insert.a)
        util.highlight('User3', theme.visual.a)
        util.highlight('User4', theme.replace.a)
        util.highlight('User5', theme.command.a)
        util.highlight('User6', theme.normal.b)
    end
end

return M
