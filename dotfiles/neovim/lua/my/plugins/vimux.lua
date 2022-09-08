local arpeggio = require("my.plugins.arpeggio")

local M = {}

function M.setup()
  arpeggio.chordSilent("n", "vp", ":VimuxPromptCommand<CR>")
  arpeggio.chordSilent("n", "vc", ":VimuxRunCommand \"clear\"<CR>")
  arpeggio.chordSilent("n", "vl", ":VimuxRunLastCommand<CR>")
end

return M
