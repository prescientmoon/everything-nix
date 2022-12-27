local M = {}

function M.setup()
  -- Import my other files
  require("my.options").setup()
  require('my.keymaps').setup()
end

return M
