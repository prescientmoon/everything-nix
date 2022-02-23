local M = {}

function M.setup()
    require('lualine').setup({
        theme = "github",

        -- Integration with other plugins
        extensions = {"nvim-tree"}
    })
end

return M
