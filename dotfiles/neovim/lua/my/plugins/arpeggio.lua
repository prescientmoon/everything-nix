local helpers = require("my.helpers")
local arpeggio = vim.fn["arpeggio#map"]

local M = {}

function M.chord(mode, lhs, rhs, opts)
  if string.len(mode) > 1 then
    for i = 1, #mode do
      local c = mode:sub(i, i)
      M.chord(c, lhs, rhs, opts)
    end
  else
    local options = helpers.mergeTables(opts, { noremap = true })
    local settings = options.settings or ""

    if options.silent then settings = settings .. "s" end

    arpeggio(mode, settings, options.noremap, lhs, rhs)
  end
end

function M.chordSilent(mode, lhs, rhs, opts)
  local options = helpers.mergeTables(opts, { silent = true })
  M.chord(mode, lhs, rhs, options)
end

return M
