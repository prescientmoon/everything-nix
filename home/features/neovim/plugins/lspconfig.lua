local M = {}

-- {{{ Capabilities
-- TODO: get rid of this once I switch to blink
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
  for lsp, details in pairs(servers) do
    vim.lsp.config(lsp, details)
    vim.lsp.enable(lsp)
  end
end
--}}}

return M
