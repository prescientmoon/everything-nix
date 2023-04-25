local M = {}

function M.setup()
  require("lazy").setup("my.plugins", {
    defaults = { lazy = true },
    disabled_plugins = {
      "gzip",
      "matchit",
      "matchparen",
      "netrwPlugin",
      "tarPlugin",
      "tohtml",
      "tutor",
      "zipPlugin",
    },
    install = {
      -- install missing plugins on startup. This doesn't increase startup time.
      missing = true,
      -- try to load one of these colorschemes when starting an installation during startup
      colorscheme = { "rose-pine", "catpuccin" },
    },
    change_detection = {
      enabled = false,
      notify = false,
    },
    performance = {
      rtp = {
        paths = {
          -- Extra runtime path specified by nix
          os.getenv("NVIM_EXTRA_RUNTIME") or "",
        },
      },
    },
  })
end

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "[L]azy ui" })

return M
