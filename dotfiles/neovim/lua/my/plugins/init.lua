local M = {}

function M.setup()
    require("my.plugins.lspconfig").setup()

    -- Other unconfigured plugins
    require('nvim-autopairs').setup()
end

return M