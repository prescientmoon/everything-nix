local map = require("my.keymaps").map

local M = {}

-- For some reason the default mappings do not work for me
function M.setup()
    vim.g.tmux_navigator_no_mappings = 1

    map("n", "<leader>h", ":TmuxNavigateLeft<cr>")
    map("n", "<leader>j", ":TmuxNavigateDown<cr>")
    map("n", "<leader>k", ":TmuxNavigateUp<cr>")
    map("n", "<leader>l", ":TmuxNavigateRight<cr>")
end

return M
