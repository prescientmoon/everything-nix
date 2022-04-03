local M = {}
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local previewers = require "telescope.previewers"
local utils = require "telescope.utils"

local add_abbreviations = false

local unicodeChars = {
    nats = "ℕ",
    rationals = "ℚ",
    reals = "ℝ",
    integers = "ℤ",
    forall = "∀",
    lambda = "λ",
    arrow = "→",
    compose = "∘",
    inverse = "⁻¹",
    dots = "…"
}

-- our picker function for unicode chars
function M.picker(opts)
    opts = opts or {}
    local results = {}

    for key, value in pairs(unicodeChars) do
        -- Name: char pair
        table.insert(results, {key, value})
    end

    print(results)

    pickers.new(opts, {
        prompt_title = "Unicode characters",
        finder = finders.new_table {
            results = results,
            entry_maker = function(entry)
                return {value = entry, display = entry[1], ordinal = entry[1]}
            end
        },
        sorter = conf.generic_sorter(opts),
        previewer = previewers.new {
            preview_fn = function(_, entry) return entry.value[2] end
        },
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()

                if selection == nil then
                    utils.__warn_no_selection "builtin.planets"
                    return
                end

                vim.api.nvim_put({selection.value[2]}, "", false, true)
                vim.cmd("startinsert")
            end)
            return true
        end
    }):find()
end

function M.setupAbbreviations(ending)
    ending = ending or ""

    if not add_abbreviations then return end

    local abbreviate = require("my.abbreviations").abbr

    for key, value in pairs(unicodeChars) do
        -- By default abbreviations are triggered using "_"
        abbreviate(key .. ending, value)
    end
end

return M
