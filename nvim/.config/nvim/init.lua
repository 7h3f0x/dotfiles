require("7h3f0x.utils")
pcall(require, "impatient")
vim.g.cursorhold_updatetime = 1000
require("7h3f0x.plugins")
if vim.v.progname ~= 'vim' then
    vim.g.initial_colorscheme = "darkplus"
else
    vim.g.initial_colorscheme = "default"
end
