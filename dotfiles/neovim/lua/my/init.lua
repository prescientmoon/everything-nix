local M = {}

function M.setup()
  -- Import my other files
  require("impatient") -- should make startups take less
  require("my.paq").setup()
  require("my.theme").setup()
  require("my.options").setup()
  require('my.keymaps').setup()
  require('my.snippets').setup()
  require('my.plugins').setup()
  require("telescope.extensions.unicode").setupAbbreviations()
end

return M
