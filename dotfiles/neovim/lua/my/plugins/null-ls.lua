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
    -- {{{ Typescript formatting
    -- null_ls.builtins.formatting.prettierd, -- format ts files
    null_ls.builtins.formatting.prettier, -- format ts files
    -- }}}
    -- {{{ Lua formatting
    -- null_ls.builtins.formatting, -- format lua code
    null_ls.builtins.formatting.stylua, -- format lua code
    -- }}}
    -- {{{ Python
    -- Formatting:
    -- null_ls.builtins.formatting.black,
    -- null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.yapf.with({
      extra_args = { [[--style="{ indent_width: 2 }"]] },
    }),
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
