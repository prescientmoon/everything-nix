local M = {}

function M.setup()
  -- require("luasnip").config.setup({ enable_autosnippets = false })
  require("luasnip.loaders.from_vscode").lazy_load()
end

return M
