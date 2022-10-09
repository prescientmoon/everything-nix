local M = {}

function M.abolish(from, to)
  vim.cmd(":Abolish " .. from .. " " .. to)
end

function M.abolishMany(many)
  for _, entry in pairs(many) do
    M.abolish(entry[1], entry[2])
  end
end

return M
