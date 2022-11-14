local lspconfig = require("my.plugins.lspconfig")

local M = {}

function M.setup()
  local null_ls = require("null-ls")

  local sources = {
    -- null_ls.builtins.formatting.prettierd.with({extra_filetypes = {}}), -- format ts files

    null_ls.builtins.formatting.prettier.with({ extra_filetypes = {} }), -- format ts files
    null_ls.builtins.formatting.lua_format.with({
      -- extra_args = function(params)
      --   return params.options and params.options.tabSize and
      --              { "--indent-width=" .. params.options.tabSize }
      -- end
    }) -- format lua code
  }

  null_ls.setup({
    sources = sources,
    on_attach = lspconfig.on_attach,
    debug = true
  })
end

return M
