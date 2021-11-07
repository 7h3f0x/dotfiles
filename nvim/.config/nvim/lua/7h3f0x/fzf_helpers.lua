
local M = {}

local fzf_run = vim.fn["fzf#run"]
local fzf_wrap = vim.fn["fzf#wrap"]

--- Prompts the user to pick a single item from a collection of entries
--- using fzf's interface
---
---@param items table Arbitrary items
---@param opts table Additional options
---     - prompt (string|nil)
---               Text of the prompt. Defaults to `Select one of:`
---     - format_item (function item -> text)
---               Function to format an
---               individual item from `items`. Defaults to `tostring`.
---@param on_choice function ((item|nil, idx|nil) -> ())
---               Called once the user made a choice.
---               `idx` is the 1-based index of `item` within `item`.
---               `nil` if the user aborted the dialog.
function M.vim_ui_select(items, opts, on_choice)
    local choices = {}

    local format_item = opts.format_item or tostring
    local width = 0
    for i, item in pairs(items) do
        local formatted = string.format('%d:%s', i, format_item(item))
        width = math.max(width, formatted:len())
        table.insert(choices, formatted)
    end

    width = math.max(width, opts.prompt:len()) + 8 + 10
    local height = 4 + #choices

    local wrapped = fzf_wrap("vim_ui_select", {
        source = choices,
        options = {
            '--prompt', opts.prompt or 'Select one of:',
            '--delimiter', ':',
            -- '--with-nth=2..',
        },
        window = {
            width = width,
            height = height
        }
    })

    wrapped.sink = nil
    wrapped["sink*"] = function(results)
        local item = vim.split(results[2], ':')
        local idx = tonumber(item[1])
        on_choice(items[idx], idx)
    end

    fzf_run(wrapped, 0)
end

return M
