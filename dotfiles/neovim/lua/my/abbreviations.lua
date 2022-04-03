local M = {}

function M.abbr(lhs, rhs)
    -- Create abbreviation
    vim.cmd(":iabbrev " .. lhs .. " " .. rhs)
end

return M
