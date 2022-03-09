local helpers = require("my.helpers")

local M = {}

function M.map(mode, lhs, rhs, opts)
    local options = helpers.mergeTables(opts, {noremap = true})
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.mapSilent(mode, lhs, rhs, opts)
    local options = helpers.mergeTables(opts, {silent = true})
    M.map(mode, lhs, rhs, options)
end

function M.setup()
    M.map("i", "jj", "<Esc>") -- Remap Esc to jj
    M.map("n", "<Space><Space>", ":w<cr>") -- Double space to sace
    M.map("n", "vv", "<C-w>v") -- Create vertical split
end

return M
