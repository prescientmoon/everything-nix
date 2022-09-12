local vscode = require("my.helpers.vscode")
local M = {}

function M.setup()
  require "gitlinker".setup()
  require('nvim_comment').setup()
  require('fidget').setup()
  require('dressing').setup()

  vscode.unless(function()
    require("presence"):setup({})
    require("my.plugins.dashboard").setup()
    require("my.plugins.treesitter").setup()
    require("my.plugins.cmp").setup()
    require("my.plugins.lspconfig").setup()
    require("my.plugins.null-ls").setup()
    require("my.plugins.nvim-tree").setup()
    require("my.plugins.vimtex").setup()
    require("my.plugins.lean").setup()
    require("my.plugins.lualine").setup()
    require("my.plugins.vimux").setup()
  end)

  require("my.plugins.easymotion").setup()
  require("my.plugins.autopairs").setup()
  require("my.plugins.paperplanes").setup()
  require("my.plugins.neogit").setup()
  require("my.plugins.telescope").setup()
  require("my.plugins.venn").setup()
  require("my.plugins.clipboard-image").setup()

  -- require("my.plugins.idris").setup()
  -- require("which-key").setup()
end

return M
