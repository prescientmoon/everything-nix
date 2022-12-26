local M = {}

function M.setup()
  -- Toggle nerdtree with Control-t
  vim.keymaps.set("n", "<C-t>", ":NERDTreeToggle<CR>", { silent = true })
end

return M
