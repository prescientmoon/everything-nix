local M = {}

function M.setup()
  -- This is here because we do not want to use neogit inside firenvim or vscode!
  vim.cmd [[packadd! neogit]]

  local neogit = require("neogit")

  neogit.setup()

  vim.keymap.set("n", "<C-g>", neogit.open)
end

return M
