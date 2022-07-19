local A = require("my.plugins.arpeggio")
local C = require("my.plugins.comment")

print("Initializing nix keybinds...")

-- Use _ug_ to fetchgit stuff
A.chordSilent("n", "ug",
  ":lua require('my.helpers.update-nix-fetchgit').update()<CR>",
  { settings = "b" })

-- Idk why this isn't here by default
C.setCommentString("nix", "# %s")
