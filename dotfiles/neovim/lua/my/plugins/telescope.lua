local mapSilent = require("my.keymaps").mapSilent
local arpeggio = require("my.plugins.arpeggio")

local M = {}

local bindings = {
    builtin = {
        -- Open files with control + P
        find_files = "<c-P>",

        -- Search through files with control + F
        live_grep = "<c-F>",

        -- See diagnostics with space + d
        lsp_document_diagnostics = "<Leader>d",
        lsp_workspace_diagnostics = "<Leader>wd",
        lsp_code_actions = "<Leader>ca",

        -- Open a list with all the pickers
        builtin = "<Leader>t",

        -- List function, var names etc
        treesitter = "<Leader>s",

        -- Git stuff
        git_commits = "<Leader>gj",
        git_branches = "<Leader>gk"
    },
    ["extensions.file_browser.file_browser"] = "<Leader>p",
    extensions = {
        unicode = {
            picker = {mode = "i", kind = "dropdown", key = "ui", chord = 1}
        }
    }
}

local function setupKeybinds(obj, path)
    if path == nil then path = "" end
    for name, keybinds in pairs(obj) do
        if (type(keybinds) == "table") and keybinds.key == nil then
            -- This means we found a table of keybinds, so we go deeper
            setupKeybinds(keybinds, path .. "." .. name)
        else
            local config = keybinds
            local pickerArgument = ""
            local key = config
            local mode = "n"
            local bind = mapSilent

            if type(config) == "table" then
                key = config.key
                if config.mode ~= nil then mode = config.mode end
                if config.kind ~= nil then
                    pickerArgument = "require('telescope.themes').get_" ..
                                         config.kind .. "({})"
                end
                if config.chord then
                    --  Useful for insert mode bindings
                    bind = arpeggio.chordSilent
                end
            end

            -- Maps the keybind to the action
            bind(mode, key,
                 "<cmd>lua require('telescope" .. path .. "')." .. name .. "(" ..
                     pickerArgument .. ")<CR>")
        end
    end
end

function M.setup()
    setupKeybinds(bindings)

    local settings = {
        defaults = {mappings = {i = {["<C-h>"] = "which_key"}}},
        pickers = {find_files = {hidden = true}},
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
