local mapSilent = require("my.keymaps").mapSilent

local M = {}

function M.setup()
    -- Open files with control + P
    mapSilent('n', '<c-P>', "<cmd>lua require('fzf-lua').files()<CR>")
end

return M