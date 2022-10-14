local arpeggio = require("my.plugins.arpeggio")

local M = {}

local function find_files_by_extension(extension)
  return "find_files find_command=rg,--files,--glob=**/*." .. extension
end

local function with_theme(base, theme)
  return base .. " theme=" .. theme
end

local defaultTheme = "ivy"

local keybinds = {
  { "<C-P>", "find_files", "Find files" },
  { "<Leader>ft", find_files_by_extension("tex"), "Find tex files" },
  { "<Leader>fl", find_files_by_extension("lua"), "Find lua files" },
  { "<Leader>fp", find_files_by_extension("purs"), "Find purescript files" },
  { "<Leader>d", "diagnostics", "Diagnostics" },
  { "<C-F>", "live_grep", "Search in project" },
  { "<Leader>t", "builtin", "Show builtin pickers" },
}

local chords = {
  { "jp", "file_browser" }
}

local function mkAction(action)
  if not string.find(action, "theme=") then
    action = with_theme(action, defaultTheme)
  end

  return ":Telescope " .. action .. "<cr>"
end

local function setupKeybinds()
  for _, mapping in pairs(keybinds) do
    vim.keymap.set("n", mapping[1], mkAction(mapping[2]), { desc = mapping[3] })
  end

  for _, mapping in pairs(chords) do
    arpeggio.chord("n", mapping[1], mkAction(mapping[2]))
  end
end

function M.setup()
  setupKeybinds()

  local settings = {
    defaults = { mappings = { i = { ["<C-h>"] = "which_key" } } },
    pickers = { find_files = { hidden = true } },
    extensions = {
      file_browser = {
        path = "%:p:h"
      }
    }
  }

  require("telescope").setup(settings)
  require("telescope").load_extension "file_browser"
end

return M
