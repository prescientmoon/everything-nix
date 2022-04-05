local A = require("my.helpers.augroup")
local map = require("my.keymaps").mapSilent
local arpeggio = require("my.plugins.arpeggio")
local M = {}

local extraBrackets = {
    lean = {{"⟨", "⟩"}}, -- lean
    all = {
        {"(", ")"}, {"[", "]"}, {"'", "'"}, {'"', '"'}, {"{", "}"}, {"`", "`"}
    } -- more general stuff
}

function M.createBracketCommand(lhs, rhs, isGlobal, opts)
    local suffix = ""
    if isGlobal then suffix = "!" end

    return ":Brackets" .. suffix .. " " .. lhs .. " " .. rhs .. " " ..
               (opts or "")
end

function M.createBracket(lhs, rhs, isGlobal, opts)
    vim.cmd(M.createBracketCommand(lhs, rhs, isGlobal, opts))
end

function M.setup()

    if arpeggio == nil then return end

    vim.g.marker_define_jump_mappings = 0 -- disable automatic binding of marker jumping (conflicts with tmux-vim-navigator)

    arpeggio.chord("inv", "sj", '<Plug>MarkersJumpF')
    arpeggio.chord("inv", "sk", '<Plug>MarkersJumpB')
    arpeggio.chord("inv", "mi", '<Plug>MarkersMark')
    arpeggio.chord("inv", "ml", '<Plug>MarkersCloseAllAndJumpToLast')
    arpeggio.chord("inv", "mo", '<Plug>MarkersJumpOutside')

    for key, brackets in pairs(extraBrackets) do
        A.augroup('custom-brackets' .. key, function()
            for _, v in ipairs(brackets) do
                local action = M.createBracketCommand(v[1], v[2], 0, v[3] or "")
                local glob = '*.' .. key

                if key == "all" then
                    -- The all key just matches everything
                    glob = "*"
                end

                A.autocmd('BufEnter', glob, action)
            end
        end)
    end
end

return M
