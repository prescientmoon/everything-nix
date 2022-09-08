local M = {}

M.deps = { { "catppuccin/nvim", as = "catppuccin" } }

function M.setup()
  local catppuccin = require("catppuccin")
  vim.g.catppuccin_flavour = os.getenv("CATPPUCCIN_FLAVOUR")

  catppuccin.setup({
    transparent_background = false,
    integrations = { nvimtree = true }
  })

  print("loaded this theme!")

  vim.cmd [[colorscheme catppuccin]]
end

return M
