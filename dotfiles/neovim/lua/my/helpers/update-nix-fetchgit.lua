local M = {}

function M.update()
    require("my.helpers").saveCursor(function()
        vim.cmd(":%!update-nix-fetchgit")
    end)
end

return M
