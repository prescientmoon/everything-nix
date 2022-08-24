local M = {}

function M.setup()
  require 'nvim-tree'.setup()
  -- Toggle nerdtree with Control-n
  vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
end

return M
