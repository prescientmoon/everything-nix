local M = {}

function M.augroup(name, inside)
    vim.cmd('augroup ' .. name)
    vim.cmd('autocmd!')
    inside()
    vim.cmd('augroup END')
end

function M.autocmd(event, glob, action)
    vim.cmd('autocmd ' .. event .. ' ' .. glob .. ' ' .. action)
end

return M
