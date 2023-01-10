local env = require("my.helpers.env")
local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

function M.config()
  local wk = require("which-key")

  local winblend = 0

  if env.neovide.active() then
    winblend = 30
  end

  wk.setup({
    window = {
      winblend = winblend,
    },
    layout = { align = "center" },
  })

  wk.register({
    ["<leader>"] = {
      f = { name = "[F]iles" },
      g = { name = "[G]o to" },
      r = { name = "[R]ename / [R]eplace / [R]eload" },
      l = { name = "[L]ocal" },
      w = { name = "[W]orkspace" },
      y = { name = "[Y]ank" },
      v = "which_key_ignore",
    },
  })
end

return M
