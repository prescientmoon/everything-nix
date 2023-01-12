local M = {
 "catppuccin/nvim", name = "catppuccin",
 lazy = false
}

function M.config()
  local catppuccin = require("catppuccin")
  vim.g.catppuccin_flavour = os.getenv("CATPPUCCIN_FLAVOUR") or "latte"

  catppuccin.setup({ transparent_background = false, integrations = { nvimtree = true } })

  vim.cmd [[highlight NotifyINFOIcon guifg=#d6b20f]]
  vim.cmd [[highlight NotifyINFOTitle guifg=#d6b20f]]

  vim.cmd [[colorscheme catppuccin]]
end

return M
