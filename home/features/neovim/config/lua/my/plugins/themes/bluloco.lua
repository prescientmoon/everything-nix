local H = require("my.tempest")

local M = {
  "uloco/bluloco.nvim",
  lazy = false,
  dependencies = { "rktjmp/lush.nvim" },
  enabled = H.theme_contains("Bluloco"),
}

function M.config()
  local bluloco = require("bluloco")

  bluloco.setup({
    transparent = H.theme.transaprency.terminal.enabled,
    style = H.theme_variant("Bluloco"),
  })

  vim.cmd("colorscheme bluloco")
end

return M
