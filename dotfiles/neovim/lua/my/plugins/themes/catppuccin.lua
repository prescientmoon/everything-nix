local H = require("my.plugins.themes.helpers")

local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  -- enabled = H.theme_contains("Catppuccin"),
  enabled = true,
}

function M.config()
  local catppuccin = require("catppuccin")
  -- vim.g.catppuccin_flavour = H.variant("Catppuccin")
  vim.g.catppuccin_flavour = "latte"

  catppuccin.setup({
    transparent_background = false,
    integrations = { nvimtree = true },
  })

  vim.cmd([[highlight NotifyINFOIcon guifg=#d6b20f]])
  vim.cmd([[highlight NotifyINFOTitle guifg=#d6b20f]])

  vim.cmd("colorscheme catppuccin")
end

return M
