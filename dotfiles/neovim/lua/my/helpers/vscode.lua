local M = {}

function M.when(f)
  if vim.g.vscode ~= nil then
    f()
  end
end

function M.unless(f)
  if vim.g.vscode == nil then
    f()
  end
end

return M
