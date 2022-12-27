local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
}

function M.config()
  local wk = require("which-key")

  wk.setup({
    triggers = { "<leader>", "d", "y", "q", "z", "g", "c" },
    show_help = true,
    show_keys = true,
  })

  wk.register({
    ["<leader>"] = {
      f = { name = "[F]iles" },
      g = { name = "[G]o to" },
      r = { name = "[R]ename / [R]eplace / [R]eload" },
      l = { name = "[L]ocal" },
      w = { name = "[W]orkspace" },
      v = "which_key_ignore",
    },
  })
end

return M
