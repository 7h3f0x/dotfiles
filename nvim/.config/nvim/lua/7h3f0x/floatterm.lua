package.loaded['7h3f0x.floatterm'] = nil

local M = {}

vim.t = vim.t or setmetatable({}, {
    __index = function(_, key)
        local is_valid, val = pcall(nvim_tabpage_get_var, 0, key)
        if is_valid then
            return val
        end
        return nil
    end
})

vim.g = vim.g or setmetatable({}, {
    __index = function(_, key)
        local is_valid, val = pcall(nvim_get_option, key)
        if is_valid then
            return val
        end
        return nil
    end
})


local function set_window_looks(win_id)

    -- set the normal highlight group in this window to our custom created group
    vim.api.nvim_win_set_option(win_id, 'winhighlight', 'Normal:BlackFloat')

    -- disable cursorcolumn and cursorline in this window
    vim.api.nvim_win_set_option(win_id, 'cursorcolumn', false)
    vim.api.nvim_win_set_option(win_id, 'cursorline', false)
end

local function create_window(buf_id)
    -- get height, width via lines, columns options
    -- can also use nvim_list_uis()[1], from which to get height and width
    local height = (vim.o and vim.o.lines) or vim.api.nvim_list_uis()[1].height
    local width = (vim.o and vim.o.columns) or vim.api.nvim_list_uis()[1].width

    -- figure out height and width for window to be created
    local term_height = vim.g["floatterm_height_scaling"] or 0.8
    term_height = height * term_height
    term_height = math.floor(term_height)

    local term_width = vim.g["floatterm_width_scaling"] or 0.8
    term_width = width * term_width
    term_width = math.floor(term_width)

    local row = math.floor((height - term_height) / 2)
    local col = math.floor((width - term_width) / 2)

    -- create buffer with given buf_id and other stats
    local win_id = vim.api.nvim_open_win(buf_id, true, {
        relative = "editor",
        width = term_width,
        height = term_height,
        col = col,
        row = row,
    })

    -- setup the looks for the window to be created
    set_window_looks(win_id)


    return win_id
end

local function create_new_terminal()

    -- create scratch buffer
    local buf_id = vim.api.nvim_create_buf(false, true)

    -- create floating window using the scratch buffer
    local win_id = create_window(buf_id)
    vim.api.nvim_command(":terminal")
    return buf_id, win_id
end

M.toggle_terminal = function()
    -- get the window and buffer ids
    local win_id = vim.t.floatterm_win_id or -1
    local buf_id = vim.g.floatterm_buf_id or -1

    if not vim.api.nvim_buf_is_valid(buf_id) then
        -- if buffer id is invalid, create new terminal buffer and window
        vim.g.floatterm_buf_id, vim.t.floatterm_win_id = create_new_terminal()
    elseif not vim.tbl_contains(vim.api.nvim_tabpage_list_wins(0), win_id) then
        -- if buffer is valid, but window is not => window was closed
        -- then create a new window with the terminal buffer id
        vim.t.floatterm_win_id = create_window(buf_id)
    else
        -- both window and buffer are valid, => toggle time, close window
        vim.api.nvim_win_close(win_id, true)
    end
end

return M

