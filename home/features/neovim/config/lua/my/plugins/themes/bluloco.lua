local H = require("my.plugins.themes.helpers")
local T = require("nix.theme")

local M = {
  "uloco/bluloco.nvim",
  lazy = false,
  dependencies = { "rktjmp/lush.nvim" },
  enabled = H.theme_contains("Bluloco"),
}

function M.config()
  local bluloco = require("bluloco")

  bluloco.setup({
    transparent = T.opacity.terminal < 1.0,
    style = H.variant("Bluloco"),
  })

  vim.cmd("colorscheme bluloco")
end

return M
