local M = {}

function M.setup()
    vim.o.foldmethod = "marker"

    --     vim.cmd([[
    --       augroup remember_folds
    -- autocmd!
    -- autocmd BufWinLeave *.* if &ft !=# 'help' | mkview | endif
    -- autocmd BufWinEnter *.* if &ft !=# 'help' | silent! loadview | endif
    --       augroup END
    --     ]])
end

return M
