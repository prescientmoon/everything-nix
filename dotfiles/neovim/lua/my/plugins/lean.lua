local lspconfig = require("my.plugins.lspconfig")
local M = {}

function M.setup()
  require('lean').setup {
    abbreviations = { builtin = true, cmp = true },
    lsp = { on_attach = lspconfig.on_attach, capabilities = lspconfig.capabilities },
    lsp3 = false,
    mappings = true
  }
end

return M
