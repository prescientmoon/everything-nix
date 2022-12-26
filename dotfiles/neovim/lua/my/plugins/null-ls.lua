local lspconfig = require("my.plugins.lspconfig")

local M = {}

function M.setup()
  local null_ls = require("null-ls")
  -- require("refactoring").setup({})

  local sources = {
    -- null_ls.builtins.formatting.prettier.with({ extra_filetypes = {} }), -- format ts files
    null_ls.builtins.formatting.prettierd.with({ extra_filetypes = {} }), -- format ts files
    -- null_ls.builtins.formatting.lua_format.with({}), -- format lua code
    null_ls.builtins.formatting.stylua.with({}), -- format lua code
    -- null_ls.builtins.code_actions.refactoring.with({}), -- refactor stuff
  }

  null_ls.setup({
    sources = sources,
    on_attach = lspconfig.on_attach,
    debug = true,
  })
end

return M
