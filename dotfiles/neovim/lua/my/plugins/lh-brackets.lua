local A = require("my.helpers.augroup")
local map = require("my.keymaps").mapSilent
local M = {}

local extraBrackets = {lean = {{"⟨", "⟩"}}}

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
    vim.g.marker_define_jump_mappings = 0 -- disable automatic binding of marker jumping (conflicts with tmux-vim-navigator)

    map("inv", "sf", '<Plug>MarkersJumpF')
    map("inv", "fs", '<Plug>MarkersJumpB')
    map("inv", "mi", '<Plug>MarkersMark')
    map("inv", "ml", '<Plug>MarkersCloseAllAndJumpToLast')
    map("inv", "mo", '<Plug>MarkersJumpOutside')

    for key, brackets in pairs(extraBrackets) do
        for _, v in ipairs(brackets) do
            A.augroup('custom-brackets' .. key, function()
                local action = M.createBracketCommand(v[1], v[2], 0, v[3] or "")
                A.autocmd('BufEnter', '*.' .. key, action)
            end)
        end
    end
end

return M
