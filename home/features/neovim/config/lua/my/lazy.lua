local M = {}

local function importFrom(p)
  return { import = p }
end

function M.setup()
  require("lazy").setup({
    require("my.themes"),
    unpack(require("nix").lazy),
  }, {
    defaults = { lazy = true },
    install = {
      -- install missing plugins on startup. this doesn't increase startup time.
      missing = true,
      -- try to load one of these colorschemes when starting an installation during startup
      colorscheme = { "rose-pine", "catpuccin" },
    },
    change_detection = {
      enabled = false,
      notify = false,
    },
    dev = {
      -- Fallback to git when local plugin doesn't exist
      fallback = true,

      -- Directory where I store my local plugin projects
      path = vim.g.nix_projects_dir,
      patterns = { "prescientmoon" },
    },
    performance = {
      rtp = {
        paths = { vim.g.nix_extra_runtime },
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
      },
    },
  })
end

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "[L]azy ui" })

return M
