package.loaded['7h3f0x.floatterm'] = nil

local M = {}


local function set_window_looks(win_id)

    -- set the normal highlight group in this window to our custom created group
    vim.api.nvim_win_set_option(win_id, 'winhl', 'Normal:BlackFloat,FloatBorder:BlackFloatBorder')

    -- disable cursorcolumn and cursorline in this window
    vim.api.nvim_win_set_option(win_id, 'cursorcolumn', false)
    vim.api.nvim_win_set_option(win_id, 'cursorline', false)
end

local function create_window(buf_id)
    -- get height, width via lines, columns options
    -- can also use nvim_list_uis()[1], from which to get height and width
    local height = vim.o.lines
    local width = vim.o.columns

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
        border = "rounded"
    })

    -- setup the looks for the window to be created
    set_window_looks(win_id)

    -- No need to resize now, it resizes automatically to fit

    -- -- resize window on vim resizing
    -- vim.cmd([[
    --     augroup plugin_floatterm
    --         autocmd!
    --         autocmd VimResized * :lua require("7h3f0x.floatterm").on_resize()
    --     augroup END
    -- ]])

    return win_id
end

local function create_new_terminal()

    -- create scratch buffer
    local buf_id = vim.api.nvim_create_buf(false, true)

    -- replace scratch buffer with a terminal buffer
    vim.api.nvim_buf_call(
        buf_id,
        function()
            vim.fn.termopen(os.getenv("SHELL") or "/bin/bash")
        end
    )

    -- create floating window using the scratch buffer
    local win_id = create_window(buf_id)
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

M.on_resize = function()
    local win_id = vim.t.floatterm_win_id or -1
    if not vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_command("autocmd! plugin_floatterm")
        return
    end
    -- get window height and width
    local height = vim.o.lines
    local width = vim.o.columns

    local term_height = vim.g["floatterm_height_scaling"] or 0.8
    term_height = height * term_height
    term_height = math.floor(term_height)

    local term_width = vim.g["floatterm_width_scaling"] or 0.8
    term_width = width * term_width
    term_width = math.floor(term_width)

    local row = math.floor((height - term_height) / 2)
    local col = math.floor((width - term_width) / 2)

    local config = {
        relative = "editor",
        width = term_width,
        height = term_height,
        col = col,
        row = row,
    }

    -- resize the actual window
    vim.api.nvim_win_set_config(win_id, config)
end

return M

