local M = {}

M.deps = { { "catppuccin/nvim", as = "catppuccin" } }

function M.setup()
  local catppuccin = require("catppuccin")
  vim.g.catppuccin_flavour = os.getenv("CATPPUCCIN_FLAVOUR")

  catppuccin.setup({ transparent_background = false, integrations = { nvimtree = true } })

  vim.cmd [[colorscheme catppuccin]]
  vim.cmd [[highlight NotifyINFOIcon guifg=#d6b20f]]
  vim.cmd [[highlight NotifyINFOTitle guifg=#d6b20f]]
end

return M
