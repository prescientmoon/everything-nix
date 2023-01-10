local env = require("my.helpers.env")

local M = {
  "kyazdani42/nvim-tree.lua",
  cmd = "NvimTreeToggle",
  config = true,
  cond = env.vscode.not_active() and env.firenvim.not_active(),
}

function M.init()
  -- Toggle nerdtree with Control-n
  vim.keymap.set(
    "n",
    "<C-n>",
    ":NvimTreeToggle<CR>",
    { desc = "Toggle [n]vim-tree" }
  )
end

return M
