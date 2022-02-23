local M = {}

function M.setup()
    -- Other unconfigured plugins
    require('nvim-autopairs').setup()
    require("startup").setup({theme = "dashboard"})

    -- Plugins with their own configs:
    require("my.plugins.cmp").setup()
    require("my.plugins.lspconfig").setup()
    require("my.plugins.null-ls").setup()
    require("my.plugins.lualine").setup()
    -- require("my.plugins.fzf-lua").setup()
    require("my.plugins.treesitter").setup()
    require("my.plugins.comment").setup()
    -- require("my.plugins.nerdtree").setup()
    require("my.plugins.nvim-tree").setup()
    require("my.plugins.vimtex").setup()
    require("my.plugins.telescope").setup()
end

return M
