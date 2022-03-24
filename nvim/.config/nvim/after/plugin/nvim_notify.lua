--- @module 'notify'

local has_notify, notify = pcall(require, "notify")

if not has_notify then
    return
end

vim.notify = notify
