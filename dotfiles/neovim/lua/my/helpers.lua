local M = {}

function M.global(name, value)
    vim.g[name] = value
end

return M
