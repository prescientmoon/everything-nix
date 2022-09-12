local M = {}

function M.setup()
  vim.keymap.set("n", "qf", "<Plug>(easymotion-bd-f)")
  vim.keymap.set("n", "qj", "<Plug>(easymotion-overwin-f2)")
  vim.keymap.set("n", "qw", "<Plug>(easymotion-bd-w)")
  vim.keymap.set("n", "qL", "<Plug>(easymotion-bd-L)")
end

return M
