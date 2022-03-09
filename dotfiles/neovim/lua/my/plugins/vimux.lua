local arpeggio = require("my.plugins.arpeggio")

local M = {}

function M.setup()
    arpeggio.chordSilent("n", "vp", ":VimuxPromptCommand<CR>")
end

return M
