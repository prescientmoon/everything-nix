local M = {}

function M.setup()
    require("my.plugins.lspconfig").setup()
    require("my.plugins.fzf-lua").setup()

    -- Other unconfigured plugins
    require('nvim-autopairs').setup()
    require('nvim_comment').setup()
end

return M
