local mapSilent = require("my.keymaps").mapSilent

local M = {}

local bindings = {
    -- Open files with control + P
    files = "<c-P>",
    -- See diagnostics with space + d
    lsp_document_diagnostics = "<space>d",
    lsp_workspace_diagnostics = "<space>D"
}

function M.setup()
    for action, keybind in pairs(bindings) do
        -- Maps the keybind to the action
        mapSilent('n', keybind, "<cmd>lua require('fzf-lua')." .. action .. "()<CR>")
    end
end

return M
