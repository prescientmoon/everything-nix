local M = {}

M.deps = { { "catppuccin/nvim", as = "catppuccin" } }

function M.setup()
  local catppuccin = require("catppuccin")

  catppuccin.setup({
    compile = { enabled = true },
    transparent_background = false,
    integrations = { nvimtree = { transparent_panel = false } }
  })
  print("loaded this theme!")

  vim.g.catppuccin_flavour = os.getenv("CATPPUCCIN_FLAVOUR")
  vim.cmd [[colorscheme catppuccin]]
end

return M
