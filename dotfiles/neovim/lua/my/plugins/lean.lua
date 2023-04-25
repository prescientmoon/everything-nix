local env = require("my.helpers.env")
local lspconfig = require("my.plugins.lspconfig")

local M = {
  "Julian/lean.nvim", -- lean support
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
  ft = "lean",
  config = function()
    require("lean").setup({
      abbreviations = { builtin = true, cmp = true },
      lsp = {
        on_attach = lspconfig.on_attach,
        capabilities = lspconfig.capabilities(),
      },
      lsp3 = false,
      mappings = true,
    })
  end,
  cond = env.vscode.not_active(),
}

return M
