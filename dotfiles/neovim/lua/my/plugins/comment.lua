local A = require("my.helpers.augroup")
local M = {}

local extraCommentStrings = {nix = "# %s", lean = "/- %s -/", bkf = "-- %s"}

-- Update comments for certain languages
local function setCommentString(extension, commentString)
    A.augroup('set-commentstring-' .. extension, function()
        local action =
            ':lua vim.api.nvim_buf_set_option(0, "commentstring", "' ..
                commentString .. '")'

        A.autocmd('BufEnter', '*.' .. extension, action)
        A.autocmd('BufFilePost', '*.' .. extension, action)
    end)
end

function M.setup()
    require('nvim_comment').setup()

    for lang, commentString in pairs(extraCommentStrings) do
        setCommentString(lang, commentString)
    end
end

return M
