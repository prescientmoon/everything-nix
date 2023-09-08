local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

function M.config()
  local wk = require("which-key")

  wk.setup({
    window = {
      winblend = 0,
      pumblend = 0,
      border = "single",
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
    },
  })
end

return M
