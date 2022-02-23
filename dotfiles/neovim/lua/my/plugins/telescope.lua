local mapSilent = require("my.keymaps").mapSilent

local M = {}

local bindings = {
    builtin = {
        -- Open files with control + P
        find_files = "<c-P>",

        -- Search through files with control + F
        live_grep = "<c-F>",

        -- See diagnostics with space + d
        lsp_document_diagnostics = "<space>d",
        lsp_workspace_diagnostics = "<space>wd",
        lsp_code_actions = "<space>ca",

        -- Open a list with all the pickers
        builtin = "<space>t",

        -- List function, var names etc
        treesitter = "<space>s",

        -- Git stuff
        git_commits = "<space>gj",
        git_branches = "<space>gk"
    },
    ["extensions.file_browser.file_browser"] = "<space>p"
}

local function setupKeybinds(obj, path)
    if path == nil then path = "" end
    for name, keybinds in pairs(obj) do
        if (type(keybinds) == "table") then
            -- This means we found a table of keybinds, so we go deeper
            setupKeybinds(keybinds, path .. "." .. name)
        else
            -- Maps the keybind to the action
            mapSilent('n', keybinds, "<cmd>lua require('telescope" .. path .. "')." .. name .. "()<CR>")
        end
    end
end

function M.setup()
    setupKeybinds(bindings)

    local settings = {
        defaults = {mappings = {i = {["<C-h>"] = "which_key"}}},
        extensions = {
            file_browser = {
                mappings = {
                    -- Comment so this does not get collapsed
                }
            }
        }
    }

    require("telescope").setup(settings)
    require("telescope").load_extension "file_browser"
end

return M
