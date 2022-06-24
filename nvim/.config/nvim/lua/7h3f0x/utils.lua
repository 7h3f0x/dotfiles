--- Print tables nicely as well without typing too much
--- Can also help in logging intermediate values
function P(v, options)
    print(vim.inspect(v, options))
    return v
end

--- Reload a package from disk
function R(pkg)
    package.loaded[pkg] = nil
    return require(pkg)
end

