local M = {}

function M.setup()
  -- Import my other files
  require("my.paq").setup()
  require("my.theme").setup()
  require("my.options").setup()
  require('my.keymaps').setup()
  require('my.plugins').setup()
  require("telescope.extensions.unicode").setupAbbreviations()
end

return M
