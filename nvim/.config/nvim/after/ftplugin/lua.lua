
-- Use vim help (works for vim.fn and vim.api and vim.* kind of things)
vim.opt.keywordprg = ':help'

-- Surround with multiline comment delims
vim.b["surround_" .. string.byte("m")] = "--[[\r]]"

-- https://github.com/tjdevries/nlua.nvim/blob/master/lua/nlua/ftplugin.lua#L34
vim.bo.include = [[\v<((do|load)file|require)[^''"]*[''"]\zs[^''"]+]]

if not __LuaIncludeHelper then
    function __LuaIncludeHelper(filename)
        -- x.y.z -> x/y/z
        local found = "lua/" .. string.gsub(filename, "%.", '/')

        -- Case: filename.lua
        local res = vim.api.nvim_get_runtime_file(found .. ".lua", 0)
        if #res > 0 then
            found = res[1]
        else
            -- Case: filename/init.lua
            res = vim.api.nvim_get_runtime_file(found .. "/init.lua", 0)
            if #res > 0 then
                found = res[1]
            else
                found = ''
            end
        end

        return found
    end
end

vim.bo.includeexpr = 'v:lua.__LuaIncludeHelper(v:fname)'
vim.opt_local.comments:prepend(":---")

