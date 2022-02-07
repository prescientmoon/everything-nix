local M = {}

-- Update comments for certain languages
local function setCommentString(extension, commentString)
    vim.cmd('autocmd BufEnter '.. extension .. ' :lua vim.api.nvim_buf_set_option(0, "commentstring", "' .. commentString .. '")')
    vim.cmd('autocmd BufFilePost '.. extension .. ' :lua vim.api.nvim_buf_set_option(0, "commentstring", "' .. commentString ..'")')
end

function M.setup()
    require('nvim_comment').setup()

    setCommentString(".nix", "# %s")
end


return M
