local map = require("my.keymaps").mapSilent

local M = {}

-- For some reason the default mappings do not work for me
function M.setup()
    vim.g.tmux_navigator_no_mappings = 1

    map("", "<C-h>", ":TmuxNavigateLeft<cr>")
    map("", "<C-j>", ":TmuxNavigateDown<cr>")
    map("", "<C-k>", ":TmuxNavigateUp<cr>")
    map("", "<C-l>", ":TmuxNavigateRight<cr>")
end

return M
