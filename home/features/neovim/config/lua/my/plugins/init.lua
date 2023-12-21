local runtime = require("my.tempest")

if runtime.whitelist("neovide") then
  require("my.neovide").setup()
end

return {
  {
    -- Better ui for inputs/selects
    "stevearc/dressing.nvim",
    config = true,
    -- https://github.com/folke/dot/blob/master/config/nvim/lua/config/plugins/init.lua
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    cond = runtime.blacklist("vscode"),
    enabled = false,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },
}
