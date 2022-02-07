local mapSilent = require("my.keymaps").mapSilent

local M = {}

function M.setup()
    -- Toggle nerdtree with Control-t
    mapSilent("n", "<C-t>", ":NERDTreeToggle<CR>")
end

return M
