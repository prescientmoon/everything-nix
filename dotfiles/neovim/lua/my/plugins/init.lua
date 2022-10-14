local env = require("my.helpers.env")
local M = {}

function M.setup()
  require('nvim_comment').setup()
  require('fidget').setup()
  require('dressing').setup()

  env.vscode.unless(function()
    env.firevim.unless(function()
      require("presence"):setup({})
      require("my.plugins.nvim-tree").setup()
      require("my.plugins.lualine").setup()
      require("my.plugins.vimux").setup()
      require("my.plugins.whichkey").setup()
      require("toggleterm").setup()

      require("my.plugins.neogit").setup()
    end)

    require("my.plugins.dashboard").setup()
    require("my.plugins.treesitter").setup()
    require("my.plugins.cmp").setup()
    require("my.plugins.luasnip").setup()
    require("my.plugins.lspconfig").setup()
    require("my.plugins.null-ls").setup()
    require("my.plugins.vimtex").setup()
    require("my.plugins.lean").setup()
  end)

  if env.firevim.active() then
    require("my.plugins.firevim").setup()
  else
    require("gitlinker").setup()
    require("my.plugins.paperplanes").setup()
  end

  require("my.plugins.easymotion").setup()
  require("my.plugins.autopairs").setup()
  require("my.plugins.telescope").setup()
  require("my.plugins.surround").setup()

  require("my.plugins.hydra").setup()
  require("my.plugins.clipboard-image").setup()
  require("my.plugins.mind").setup()

  -- require("my.plugins.slam").setup()
end

return M
