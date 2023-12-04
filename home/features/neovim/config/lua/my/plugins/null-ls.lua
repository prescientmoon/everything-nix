local env = require("my.helpers.env")

local M = {
  "jose-elias-alvarez/null-ls.nvim", -- generic language server
  event = "BufReadPre",
  dependencies = "neovim/nvim-lspconfig",
  cond = env.vscode.not_active(),
  enable = false,
}

function M.config()
  local lspconfig = require("my.plugins.lspconfig")
  local null_ls = require("null-ls")

  local sources = {
    -- {{{ Python
    -- Diagnostics
    null_ls.builtins.diagnostics.ruff, -- Linting
    -- null_ls.builtins.diagnostics.mypy, -- Type checking
    -- }}}
  }

  null_ls.setup({
    sources = sources,
    on_attach = lspconfig.on_attach,
    debug = true,
  })
end

return M
