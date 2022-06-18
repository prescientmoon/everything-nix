local helpers = require("my.helpers")
local arpeggio = require("my.plugins.arpeggio")
local au = require("my.helpers.augroup")

local M = {}

function M.map(mode, lhs, rhs, opts)
    if string.len(mode) > 1 then
        for i = 1, #mode do
            local c = mode:sub(i, i)
            M.map(c, lhs, rhs, opts)
        end
    else
        local options = helpers.mergeTables(opts, {noremap = true})
        vim.api.nvim_set_keymap(mode, lhs, rhs, options)
    end
end

function M.mapSilent(mode, lhs, rhs, opts)
    local options = helpers.mergeTables(opts, {silent = true})
    M.map(mode, lhs, rhs, options)
end

function M.setup()
    M.map("n", "vv", "<C-w>v") -- Create vertical split
    M.map("n", "qq", ":wq<cr>") -- Create vertical split

    if arpeggio ~= nil then
        -- Create chords
        arpeggio.chord("n", "ji", ":w<cr>") -- Saving
        arpeggio.chord("i", "jk", "<Esc>") -- Remap Esc to jk
        arpeggio.chord("i", "<Leader>k", "<C-k><cr>") -- Rebind digraph insertion to leader+k
        arpeggio.chord("inv", "<Leader>a", "<C-6><cr>") -- Rebind switching to the last pane using leader+a
        arpeggio.chord("nv", "cp", "\"+") -- Press cp to use the global clipboard
    end

    return M
end

return M
