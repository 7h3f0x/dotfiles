
-- Things I will need if pyls_ms is removed from here as well
--[[

-- LSP extensions
local pyls_ms = require('lsp-status/extensions/pyls_ms') -- will need to change this
local clangd = require('lsp-status/extensions/clangd')
local extension_callbacks = {pyls_ms = pyls_ms, clangd = clangd}

-- Find current enclosing function
local current_function = require('lsp-status/current_function')

-- Out-of-the-box statusline component
local redraw = require('lsp-status/redraw')
local statusline = require('lsp-status/statusline')

.
.
.

local function config(user_config)
  _config = vim.tbl_extend('keep', user_config, _config, default_config)
  pyls_ms._init(messages, _config)
  clangd._init(messages, _config)
  messaging._init(messages, _config)
  if _config.current_function then current_function._init(messages, _config) end
  statusline._init(messages, _config)
  redraw._init(messages, _config)
  statusline = vim.tbl_extend('keep', statusline, statusline._get_component_functions())
end

--]]


local util = require('lsp-status/util')
local redraw = require('lsp-status/redraw')

local messages = {}
---@private
local function init(_messages, _) messages = _messages end

---@private
local function ensure_init(id) util.ensure_init(messages, id, 'pyls_ms') end

local handlers = {
    ['python/setStatusBarMessage'] = util.mk_handler(function(_, message, ctx, _)
        local client_id = ctx.client_id
        ensure_init(client_id)
        messages[client_id].static_message = {content = message[1]}
        redraw.redraw()
    end),
    ['python/beginProgress'] = util.mk_handler(function(_, _, ctx, _)
        local client_id = ctx.client_id
        ensure_init(client_id)
        if not messages[client_id].progress[1] then
            messages[client_id].progress[1] = {spinner = 1, title = 'MPLS'}
        end
    end),
    ['python/reportProgress'] = util.mk_handler(function(_, message, ctx, _)
        local client_id = ctx.client_id
        messages[client_id].progress[1].spinner = messages[client_id].progress[1].spinner + 1
        messages[client_id].progress[1].title = message[1]
        redraw.redraw()
    end),
    ['python/endProgress'] = util.mk_handler(function(_, _, ctx, _)
        local client_id = ctx.client_id
        messages[client_id].progress[1] = nil
        redraw.redraw()
    end)
}

--- Return the handler {LSP Method: handler} table for `MPLS`'s progress and statusbar message
--- extensions
-- @returns Table of extension method handlers, to be added to your `pyls_ms` config
local function setup() return handlers end

local M = {_init = init, setup = setup}

M = vim.tbl_extend('error', M, handlers)

return M
