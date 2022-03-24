--- @module 'fidget'
local has_fidget, fidget = pcall(require, "fidget")

if not has_fidget then
    return
end

fidget.setup({
    text = {
        spinner = "dots_negative"
    }
})
