local M = {}

function M.setup()
    require("my.plugins.cmp").setup()
    require("my.plugins.lspconfig").setup()
    -- require("my.plugins.fzf-lua").setup()
    require("my.plugins.telescope").setup()
    require("my.plugins.treesitter").setup()
    require("my.plugins.comment").setup()
    -- require("my.plugins.nerdtree").setup()
    require("my.plugins.nvim-tree").setup()
    require("my.plugins.vimtex").setup()

    -- Other unconfigured plugins
    require('nvim-autopairs').setup()
    require("startup").setup({theme = "dashboard"})
    require('lualine').setup({theme = "github"})
end

return M
