local helpers = require("my.helpers")
local arpeggio = vim.fn["arpeggio#map"]

local M = {}

---Create an arpeggio mapping
---@param mode string
---@param lhs string
---@param rhs string
---@param opts table|nil
local function chord(mode, lhs, rhs, opts)
  if string.len(mode) > 1 then
    for i = 1, #mode do
      local c = mode:sub(i, i)
      chord(c, lhs, rhs, opts)
    end
  else
    local options = helpers.mergeTables(opts or {}, { noremap = true })
    local settings = options.settings or ""

    if options.silent then
      settings = settings .. "s"
    end

    arpeggio(mode, settings, not options.noremap, lhs, rhs)
  end
end

---Create a silent arpeggio mapping
---@param mode string
---@param lhs string
---@param rhs string
---@param opts table|nil
local function chordSilent(mode, lhs, rhs, opts)
  local options = helpers.mergeTables(opts or {}, { silent = true })
  chord(mode, lhs, rhs, options)
end

function M.setup()
  chordSilent("n", "ji", ":silent :write<cr>") -- Saving
  chord("i", "jk", "<Esc>") -- Remap Esc to jk
  chord("nv", "cp", '"+') -- Press cp to use the global clipboard
end

return M
