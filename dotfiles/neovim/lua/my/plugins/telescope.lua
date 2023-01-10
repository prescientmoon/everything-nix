local env = require("my.helpers.env")

local telescope = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-lua/plenary.nvim"
  },
  version = "0.1.x",
  pin = true,
  cond = env.vscode.not_active(),
}

local M = telescope

local function find_files_by_extension(extension)
  return "find_files find_command=rg,--files,--glob=**/*." .. extension
end

local function with_theme(base, theme)
  return base .. " theme=" .. theme
end

local defaultTheme = "ivy"

local keybinds = {
  { "<C-P>", "find_files", "Find files" },
  { "<Leader>ft", find_files_by_extension("tex"), "[F]ind [t]ex files" },
  { "<Leader>fl", find_files_by_extension("lua"), "[F]ind [l]ua files" },
  {
    "<Leader>fp",
    find_files_by_extension("purs"),
    "[F]ind [p]urescript files",
  },
  { "<Leader>d", "diagnostics", "[D]iagnostics" },
  { "<C-F>", "live_grep", "[F]ind in project" },
  { "<C-S-F>", "file_browser", "[F]ile browser" },
  { "<Leader>t", "builtin", "[T]elescope pickers" },
}

local function mkAction(action)
  if not string.find(action, "theme=") then
    action = with_theme(action, defaultTheme)
  end

  if not string.find(action, "winblend=") and env.neovide.active() then
    action = action .. " winblend=45"
  end

  return "<cmd>Telescope " .. action .. "<cr>"
end

function telescope.init()
  for _, mapping in pairs(keybinds) do
    vim.keymap.set("n", mapping[1], mkAction(mapping[2]), { desc = mapping[3] })
  end
end

function telescope.config()
  local settings = {
    defaults = { mappings = { i = { ["<C-h>"] = "which_key" } } },
    pickers = { find_files = { hidden = true } },
    extensions = {
      file_browser = { path = "%:p:h" },
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
      },
    },
  }

  require("telescope").setup(settings)
  require("telescope").load_extension("fzf")
  require("telescope").load_extension("file_browser")
end

return M
