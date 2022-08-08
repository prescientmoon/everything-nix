local helpers = require("my.helpers")
local arpeggio = require("my.plugins.arpeggio")

local M = {}

function M.map(mode, lhs, rhs, opts)
  if string.len(mode) > 1 then
    for i = 1, #mode do
      local c = mode:sub(i, i)
      M.map(c, lhs, rhs, opts)
    end
  else
    local options = helpers.mergeTables(opts, { noremap = true })
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end
end

function M.mapSilent(mode, lhs, rhs, opts)
  local options = helpers.mergeTables(opts, { silent = true })
  M.map(mode, lhs, rhs, options)
end

function M.setup()
  M.map("n", "qq", ":wq<cr>") -- Save and quit

  -- Create chords
  if arpeggio ~= nil then
    arpeggio.chord("n", "vs", "<C-w>v") -- Create vertical split
    arpeggio.chord("n", "vs", "<C-w>v") -- Create vertical split
    arpeggio.chord("n", "ji", ":w<cr>") -- Saving
    arpeggio.chord("i", "jk", "<Esc>") -- Remap Esc to jk
    arpeggio.chord("inv", "<Leader>a", "<C-6><cr>") -- Rebind switching to the last pane using leader+a
    arpeggio.chord("nv", "cp", "\"+") -- Press cp to use the global clipboard
    arpeggio.chord("n", "rw", ":%s/<C-r><C-w>/") -- Press rw to rename word under cursor
  end

  return M
end

return M
