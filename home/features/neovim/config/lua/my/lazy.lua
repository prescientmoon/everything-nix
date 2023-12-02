local M = {}

local function importFrom(p)
  return { import = p }
end

function M.setup()
  require("lazy").setup(
    { importFrom("my.plugins"), importFrom("nix.plugins") },
    {
      defaults = { lazy = true },
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
      dev = {
        -- Fallback to git when local plugin doesn't exist
        fallback = true,

        -- Directory where I store my local plugin projects
        path = "~/Projects",

        patterns = { "Mateiadrielrafael" },
      },
      performance = {
        rtp = {
          paths = {
            -- Extra runtime path specified by nix
            os.getenv("NVIM_EXTRA_RUNTIME") or "",
          },
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
    }
  )
end

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "[L]azy ui" })

return M
