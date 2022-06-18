local M = {}

M.deps = {{"catppuccin/nvim", as = "catppuccin"}}

function M.setup()
    local catppuccin = require("catppuccin")

    catppuccin.setup({
        transparent_background = false,
        integrations = {nvimtree = {transparent_panel = false}}
    })

    vim.g.catppuccin_flavour = os.getenv("CATPPUCCIN_FLAVOUR")
    vim.cmd [[colorscheme catppuccin]]
end

return M
