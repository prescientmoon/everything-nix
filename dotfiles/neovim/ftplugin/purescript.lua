local arpeggio = require("my.plugins.arpeggio")
local A = require("my.abbreviations")

print("Initializing nix keybinds...")

-- Use vt to test
arpeggio.chordSilent("n", "vt", ":VimuxRunCommand \"clear && spago test\"<CR>",
  { settings = "b" })

-- Use vb to build
arpeggio.chordSilent("n", "vb", ":VimuxRunCommand \"clear && spago build\"<CR>",
  { settings = "b" })

vim.opt.expandtab = true -- Use spaces for the tab char

local abbreviations = {
  { "land", "/\\" },
  { "lor", "\\/" },
  { "tto", "->" },
  { "iip", "=>" },
  { "frl", "forall" },
  { "ott", "<-" } -- opposite of tto
}

A.manyLocalAbbr(abbreviations)
