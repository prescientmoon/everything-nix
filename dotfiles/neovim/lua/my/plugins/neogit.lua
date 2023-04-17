local env = require("my.helpers.env")

local M = {
  "TimUntersberger/neogit",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Neogit",
  cond = env.firenvim.not_active() and env.vscode.not_active(),
  init = function()
    vim.keymap.set("n", "<C-g>", "<cmd>Neogit<cr>", { desc = "Open neo[g]it" })
  end,
  config = function()
    require("neogit").setup()

    -- {{{ Disable folds inside neogit
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "NeogitStatus" },
      group = vim.api.nvim_create_augroup("NeogitStatusOptions", {}),
      callback = function()
        vim.opt.foldenable = false
      end,
    })
    -- }}}
  end,
}

return M
