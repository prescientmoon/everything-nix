local M = {}

function M.setup()
  -- Import my other files
  require("my.options").setup()
  require("my.keymaps").setup()
  require("my.lazy").setup()
end

return M
