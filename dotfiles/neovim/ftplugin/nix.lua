local A = require("my.plugins.arpeggio")

print("Initializing nix keybinds...")

-- Use _ug_ to fetchgit stuff
A.chordSilent("n", "ug",
  ":lua require('my.helpers.update-nix-fetchgit').update()<CR>",
  { settings = "b" })

-- Idk why this isn't here by default
vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
