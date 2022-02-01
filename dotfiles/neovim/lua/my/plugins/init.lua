local M = {}

function M.setup()
    require("my.plugins.lspconfig").setup()
    require("my.plugins.fzf-lua").setup()
    require("my.plugins.treesitter").setup()

    -- Other unconfigured plugins
    require('nvim-autopairs').setup()
    require('nvim_comment').setup()
    require("startup").setup({theme = "dashboard"})
end

return M
