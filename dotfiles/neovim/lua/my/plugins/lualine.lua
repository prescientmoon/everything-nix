local M = {}

function M.setup()
    require('lualine').setup({
        theme = vim.g.lualineTheme,

        -- Integration with other plugins
        extensions = {"nvim-tree"}
    })
end

return M
