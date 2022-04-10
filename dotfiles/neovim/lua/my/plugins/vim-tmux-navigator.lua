local map = require("my.keymaps").mapSilent

local M = {}

-- For some reason the default mappings do not work for me
function M.setup()
    vim.g.tmux_navigator_no_mappings = 1

    map("inv", "<C-h>", ":TmuxNavigateLeft<cr>")
    map("inv", "<C-j>", ":TmuxNavigateDown<cr>")
    map("inv", "<C-k>", ":TmuxNavigateUp<cr>")
    map("inv", "<C-l>", ":TmuxNavigateRight<cr>")
end

return M
