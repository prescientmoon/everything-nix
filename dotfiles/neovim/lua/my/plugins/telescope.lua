local mapSilent = require("my.keymaps").mapSilent

local M = {}

local bindings = {
    -- Open files with control + P
    find_files = "<c-P>",

    -- Search through files with control + F
    live_grep = "<c-F>",

    -- See diagnostics with space + d
    diagnotics = "<space>d",

    -- Open a list with all the pickers
    builtin = "<space>t",

    -- List function, var names etc
    treesitter = "<space>s",

    -- Git stuff
    git_commits = "<space>gj",
    git_branches = "<space>gk"
}

function M.setup()
    for action, keybind in pairs(bindings) do
        -- Maps the keybind to the action
        mapSilent('n', keybind, "<cmd>lua require('telescope.builtin')." .. action .. "()<CR>")
    end

    require("telescope").setup {defaults = {mappings = {i = {["<C-h>"] = "which_key"}}}}
end

return M
