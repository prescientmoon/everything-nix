local env = require("my.helpers.env")

local M = {
  "glepnir/dashboard-nvim",
  event = "VimEnter",
  opts = {
    theme = "hyper",
    config = {
      week_header = {
        enable = true,
      },
      -- TODO: actually customize these
      shortcut = {
        {
          desc = " Update",
          group = "@property",
          action = "Lazy update",
          key = "u",
        },
        {
          desc = " Files",
          group = "Label",
          action = "Telescope find_files",
          key = "f",
        },
        {
          desc = " Apps",
          group = "DiagnosticHint",
          action = "Telescope app",
          key = "a",
        },
        {
          desc = " dotfiles",
          group = "Number",
          action = "Telescope dotfiles",
          key = "d",
        },
      },
    },
  },
  cond = env.vscode.not_active() and env.firenvim.not_active(),
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}

return M
