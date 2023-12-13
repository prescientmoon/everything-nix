local env = require("my.helpers.env")

if env.neovide.active() then
  require("my.neovide").setup()
end

return {
  --{{{ Language support
  {
    "purescript-contrib/purescript-vim",
    ft = "purescript",
    cond = env.vscode.not_active(),
  },

  {
    "elkowar/yuck.vim",
    ft = "yuck",
    cond = env.vscode.not_active(),
  },

  {
    "Fymyte/rasi.vim",
    ft = "rasi",
    cond = env.vscode.not_active(),
  },

  {
    "teal-language/vim-teal",
    ft = "teal",
    cond = env.vscode.not_active(),
  },

  {
    "udalov/kotlin-vim",
    ft = "kotlin",
    cond = env.vscode.not_active(),
  },

  {
    "kmonad/kmonad-vim",
    ft = "kbd",
    cond = env.vscode.not_active(),
  },

  {
    "vmchale/dhall-vim",
    ft = "dhall",
    cond = env.vscode.not_active(),
  },

  {
    "yasuhiroki/github-actions-yaml.vim",
    ft = { "yml", "yaml" },
    cond = env.vscode.not_active(),
  },

  {
    "kaarmu/typst.vim",
    ft = "typst",
    cond = env.vscode.not_active(),
  },

  {
    "theRealCarneiro/hyprland-vim-syntax",
    ft = "hypr",
    cond = env.vscode.not_active(),
  },
  --}}}

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
    cond = env.vscode.not_active(),
    enabled = false,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  {
    "mateiadrielrafael/scrap.nvim",
    event = "InsertEnter",
    config = function()
      require("my.abbreviations").setup()
    end,
  }, -- vim-abolish rewrite

  {
    -- easly switch between tmux and vim panes
    "christoomey/vim-tmux-navigator",
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
    cond = env.vscode.not_active()
      and env.neovide.not_active()
      and env.firenvim.not_active()
      and false,
  },

  {
    -- show progress for lsp stuff
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "BufReadPre",
    cond = env.vscode.not_active(),
    config = true,
  },

  -- Live command preview for stuff like :norm
  {
    "smjonas/live-command.nvim",
    config = function()
      require("live-command").setup({
        commands = {
          Norm = { cmd = "norm" },
        },
      })
    end,
    event = "VeryLazy",
    cond = false,
  },
}
