local helpers = require("my.helpers")
local arpeggio = vim.fn["arpeggio#map"]

local M = {}

function M.chord(mode, lhs, rhs, opts)
    local options = helpers.mergeTables(opts, {noremap = true})

    local settings = ""

    if options.silent then settings = settings .. "s" end

    arpeggio(mode, settings, options.noremap, lhs, rhs)
end

function M.chordSilent(mode, lhs, rhs, opts)
    local options = helpers.mergeTables(opts, {silent = true})
    M.chord(mode, lhs, rhs, options)
end

return M
