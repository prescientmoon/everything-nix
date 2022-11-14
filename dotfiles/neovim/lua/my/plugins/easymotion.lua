local M = {}

function M.setup()
  local opts = function(desc)
    return { desc = desc, silent = true }
  end

  local modes = { "n", "v", "o" }

  vim.keymap.set(modes, "qf", "<Plug>(easymotion-bd-f)", opts("Hop to char"))
  vim.keymap.set(modes, "qj", "<Plug>(easymotion-overwin-f2)", opts("Hop to char pair"))
  vim.keymap.set(modes, "qw", "<Plug>(easymotion-bd-w)", opts("Hop to word"))
  vim.keymap.set(modes, "qL", "<Plug>(easymotion-bd-L)", opts("Hop to line (?)"))

  local status, wk = pcall(require, "which-key")

  if status then wk.register({ q = { name = "Easymotion" } }, { mode = "o" }) end
end

return M
