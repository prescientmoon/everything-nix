local wk = require("which-key")

local M = {}

function M.setup()
  wk.setup({
    triggers = { "<leader>", "d", "y", "q", "z", "g", "c" },
    show_help = false,
    show_keys = false
  })

  wk.register({ ["<leader>l"] = { name = "Local commands" } })
end

return M
