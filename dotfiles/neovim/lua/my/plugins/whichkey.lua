local M = {}

function M.setup()
  require("which-key").setup({
    triggers = { "<leader>", "d", "y", "q", "z", "g", "c" }
  })
end

return M
