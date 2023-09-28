local env = require("my.helpers.env")
local vault = "/home/adrielus/Projects/stellar-sanctum"

return {
  "epwalsh/obsidian.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    dir = vault,
    notes_subdir = "chaos",
    daily_notes = {
      folder = "daily",
      date_format = "%Y-%m-%d",
    },
    completion = {
      nvim_cmp = true,
      min_chars = 2,
      new_notes_location = "current_dir",
      prepend_note_id = true,
    },
    mappings = {},
    disable_frontmatter = true,
  },
  keys = {
    { "<C-O>", "<cmd>ObsidianQuickSwitch<cr>" },
  },
  cond = env.vscode.not_active()
    and env.firenvim.not_active()
    and vim.loop.cwd() == vault,
}
