local H = require("my.helpers.theme")

local M = {
  "uloco/bluloco.nvim",
  lazy = false,
  dependencies = { "rktjmp/lush.nvim" },
  enabled = H.theme_contains("Bluloco"),
}

function M.config()
  local bluloco = require("bluloco")

  bluloco.setup({
    transparent = H.theme.opacity.terminal < 1.0,
    style = H.variant("Bluloco"),
  })

  vim.cmd("colorscheme bluloco")
end

return M
