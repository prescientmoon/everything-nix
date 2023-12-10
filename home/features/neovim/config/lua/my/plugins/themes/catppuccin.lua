local H = require("my.plugins.themes.helpers")
local T = require("nix.theme")

local M = {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  enabled = H.theme_contains("Catppuccin"),
}

function M.config()
  local catppuccin = require("catppuccin")
  vim.g.catppuccin_flavour = H.variant("Catppuccin")

  catppuccin.setup({
    transparent_background = T.transparent.terminal,
    integrations = { nvimtree = true, telescope = true },
  })

  vim.cmd([[highlight NotifyINFOIcon guifg=#d6b20f]])
  vim.cmd([[highlight NotifyINFOTitle guifg=#d6b20f]])

  vim.cmd("colorscheme catppuccin")

  if T.transparent.terminal then
    vim.cmd([[highlight FloatBorder blend=0]])
  end
end

return M
