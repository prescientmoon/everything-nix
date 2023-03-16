-- Use vt to test
vim.keymap.set(
  "n",
  "<leader>vt",
  ':VimuxRunCommand "clear && spago test"<CR>',
  { desc = "[V]imtex run [t]ests", buffer = true }
)

-- Use vb to build
vim.keymap.set(
  "n",
  "<leader>vb",
  ':VimuxRunCommand "clear && spago build"<CR>',
  { desc = "[V]imtex [b]uild", buffer = true }
)

vim.opt.expandtab = true -- Use spaces for the tab char

require("my.abbreviations.fp").setup()
