local arpeggio = require("my.plugins.arpeggio")

local M = {}

local function find_files_by_extension(extension)
  return "find_files find_command=rg,--files,--glob=**/*." .. extension
end

local keybinds = {
  { "<C-P>", "find_files" },
  { "<Leader>ft", find_files_by_extension("tex") },
  { "<Leader>fl", find_files_by_extension("lua") },
  { "<C-F>", "live_grep" },
  { "<Leader>t", "builtin" },
}

local chords = {
  { "jp", "file_browser" }
}

local function mkAction(action)
  return ":Telescope " .. action .. "<cr>"
end

local function setupKeybinds()
  for _, mapping in pairs(keybinds) do
    vim.keymap.set("n", mapping[1], mkAction(mapping[2]))
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
