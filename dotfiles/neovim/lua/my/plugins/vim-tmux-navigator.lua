local map = require("my.keymaps").map

local M = {}

-- For some reason the default mappings do not work for me
function M.setup()
  vim.g.tmux_navigator_no_mappings = 1

  map("n", "<C-h>", ":TmuxNavigateLeft<cr>")
  map("n", "<C-j>", ":TmuxNavigateDown<cr>")
  map("n", "<C-k>", ":TmuxNavigateUp<cr>")
  map("n", "<C-l>", ":TmuxNavigateRight<cr>")
end

return M
