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
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup()
    end,
  },

  -- Helper libs
  {
    "nvim-lua/plenary.nvim",
    -- Autoload when running tests
    cmd = { "PlenaryBustedDirectory", "PlenaryBustedFile" },
  },
  "MunifTanjim/nui.nvim",
  "nvim-tree/nvim-web-devicons", -- nice looking icons
  {
    "mateiadrielrafael/scrap.nvim",
    event = "InsertEnter",
    config = function()
      require("my.abbreviations").setup()
    end,
  }, -- vim-abolish rewrite

  {
    "terrortylor/nvim-comment",
    keys = { "gc", "gcc", { "gc", mode = "v" } },
    config = function()
      require("nvim_comment").setup()
    end,
  },

  {
    -- easly switch between tmux and vim panes
    "christoomey/vim-tmux-navigator",
    keys = { "<C-h>", "<C-j>", "<C-k>", "<C-l>" },
    cond = env.vscode.not_active()
      and env.neovide.not_active()
      and env.firenvim.not_active(),
  },

  {
    -- track time usage
    "wakatime/vim-wakatime",
    event = "VeryLazy",
    cond = env.vscode.not_active() and env.firenvim.not_active(),
  },

  {
    -- show progress for lsp stuff
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "BufReadPre",
    cond = env.vscode.not_active(),
    config = true,
  },

  {
    -- export to pastebin like services
    "rktjmp/paperplanes.nvim",
    opts = {
      provider = "paste.rs",
    },
    cmd = "PP",
  },

  {
    -- case switching + the subvert command
    "tpope/vim-abolish",
    event = "VeryLazy",
    enabled = false,
  },

  {
    -- automatically set options based on current file
    "tpope/vim-sleuth",
    event = "BufRead",
    cond = env.vscode.not_active(),
  },

  {
    -- generate permalinks for code
    "ruifm/gitlinker.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { mappings = "<leader>yg" },
    init = function()
      local status, wk = pcall(require, "which-key")

      if status then
        wk.register({
          ["<leader>yg"] = {
            desc = "[Y]ank [g]it remote url",
          },
        })
      end
    end,
    cond = env.firenvim.not_active(),
    keys = "<leader>yg",
  },

  {
    -- discord rich presence
    "andweeb/presence.nvim",
    cond = env.vscode.not_active() and env.firenvim.not_active(),
    config = function()
      require("presence"):setup()
    end,
    event = "VeryLazy",
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
    -- cond = false,
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    init = function()
      vim.keymap.set(
        "n",
        "<leader>u",
        "<cmd>UndotreeToggle<cr>",
        { desc = "[U]ndo tree" }
      )
    end,
  },
}
