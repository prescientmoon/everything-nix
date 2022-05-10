local M = {}

function M.global(name, value) vim.g[name] = value end

function M.mergeTables(t1, t2)
    local t3 = {}

    if t1 ~= nil then for k, v in pairs(t1) do t3[k] = v end end

    if t2 ~= nil then for k, v in pairs(t2) do t3[k] = v end end

    return t3
end

function M.saveCursor(callback)
    local cursor = vim.api.nvim_win_get_cursor()
    callback()
    vim.api.nvim_win_set_cursor(cursor)
end

return M
