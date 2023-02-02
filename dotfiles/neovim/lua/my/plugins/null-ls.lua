local env = require("my.helpers.env")

local M = {
  "jose-elias-alvarez/null-ls.nvim", -- generic language server
  event = "BufReadPre",
  dependencies = "neovim/nvim-lspconfig",
  cond = env.vscode.not_active(),
}

function M.config()
  local lspconfig = require("my.plugins.lspconfig")
  local null_ls = require("null-ls")

  local sources = {
    null_ls.builtins.formatting.prettier.with({ extra_filetypes = {} }), -- format ts files
    -- null_ls.builtins.formatting.prettierd.with({ extra_filetypes = {} }), -- format ts files
    null_ls.builtins.formatting.stylua.with({}), -- format lua code
    -- null_ls.builtins.formatting.lua_format.with({}), -- format lua code
  }

  null_ls.setup({
    sources = sources,
    on_attach = lspconfig.on_attach,
    debug = true,
  })
end

return M
