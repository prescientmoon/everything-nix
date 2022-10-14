local wk = require("which-key")

local M = {}

function M.setup()
  wk.setup({
    triggers = { "<leader>", "d", "y", "q", "z", "g", "c" }
  })

  wk.register({
    ["<leader>l"] = {
      name = "Local commands"
    }
  })
end

return M
