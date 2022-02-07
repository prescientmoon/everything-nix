local mapSilent = require("my.keymaps").mapSilent

local M = {}

function M.setup()
    require'nvim-tree'.setup()
    -- Toggle nerdtree with Control-t
    mapSilent("n", "<C-t>", ":NvimTreeToggle<CR>")
end

return M
