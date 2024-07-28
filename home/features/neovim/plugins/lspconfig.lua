local M = {}

-- {{{ Capabilities
M.capabilities = function()
  local c = require("cmp_nvim_lsp").default_capabilities()

  -- Add folding capabilities
  c.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  return c
end
-- }}}
-- {{{ Main config function
function M.config(servers)
  local lspconfig = require("lspconfig")

  local capabilities = M.capabilities()
  for lsp, details in pairs(servers) do
    details.capabilities = capabilities
    lspconfig[lsp].setup(details)
  end
end
--}}}

return M
