local M = {}

function M.setup()
  require("luasnip.loaders.from_vscode").lazy_load({})
end

return M
