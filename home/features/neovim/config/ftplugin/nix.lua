-- Use _<leader>lg_ to fetchgit stuff
vim.keymap.set("n", "<leader>lg", function()
  require("my.tempest").withSavedCursor(function()
    vim.cmd(":%!update-nix-fetchgit")
  end)
end, { buffer = true, desc = "Update all fetchgit calls" })

-- Idk why this isn't here by default
vim.api.nvim_buf_set_option(0, "commentstring", "# %s")
