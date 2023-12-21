local H = require("my.helpers.theme")

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
    transparent_background = H.theme.transparent.terminal,
    integrations = {
      nvimtree = true,
      telescope = true,
      mini = { enabled = true },
    },
  })

  vim.cmd([[highlight NotifyINFOIcon guifg=#d6b20f]])
  vim.cmd([[highlight NotifyINFOTitle guifg=#d6b20f]])

  vim.cmd("colorscheme catppuccin")

  if H.theme.transparent.terminal then
    vim.cmd([[highlight FloatBorder blend=0 guibg=NONE]])
    -- vim.cmd([[highlight MiniStatuslineInactive blend=0 guibg=NONE]])
    vim.cmd([[highlight MiniStatuslineFilename blend=0 guibg=NONE]])
    -- vim.cmd([[highlight MiniStatuslineFileinfo blend=0 guibg=NONE]])
    -- vim.cmd([[highlight MiniStatuslineDevInfo blend=0 guibg=NONE]])
    vim.cmd([[highlight Statusline blend=0 guibg=NONE]])
    vim.cmd([[highlight StatuslineNC blend=0 guibg=NONE]])
  end
end

return M
