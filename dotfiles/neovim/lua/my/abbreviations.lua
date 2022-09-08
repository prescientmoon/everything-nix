local M = {}

function M.localAbbr(lhs, rhs)
  -- Create abbreviation
  vim.cmd(":iabbrev <buffer>" .. lhs .. " " .. rhs)
end

function M.manyLocalAbbr(abbreviations)
  for _, value in pairs(abbreviations) do
    M.localAbbr(value[1], value[2])
  end
end

function M.abbr(lhs, rhs)
  -- Create abbreviation
  vim.cmd(":iabbrev " .. lhs .. " " .. rhs)
end

return M
