local M = {}

function M.setup()
    -- Other unconfigured plugins
    require('nvim-autopairs').setup()
    require("startup").setup({theme = "dashboard"})
    require("presence"):setup({}) -- wtf does the : do here?

    -- Plugins with their own configs:
    -- require("my.plugins.fzf-lua").setup()
    -- require("my.plugins.nerdtree").setup()
    require("my.plugins.cmp").setup()
    require("my.plugins.lspconfig").setup()
    require("my.plugins.null-ls").setup()
    require("my.plugins.lualine").setup()
    require("my.plugins.treesitter").setup()
    require("my.plugins.comment").setup()
    require("my.plugins.nvim-tree").setup()
    require("my.plugins.vimtex").setup()
    require("my.plugins.telescope").setup()
    require("my.plugins.vimux").setup()
    -- require("my.plugins.idris").setup()
    require("my.plugins.lean").setup()
    require("my.plugins.vim-tmux-navigator").setup()
    require("my.plugins.lh-brackets").setup()
end

return M
