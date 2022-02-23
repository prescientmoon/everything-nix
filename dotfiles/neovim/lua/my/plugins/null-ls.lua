local M = {}

function M.setup()
    local null_ls = require("null-ls")

    local sources = {
        null_ls.builtins.formatting.prettierd -- format ts files
    }

    null_ls.setup({sources = sources})
end

return M
