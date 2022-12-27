local M = {}

function M.setup()
  vim.g.neovide_floating_blur_amount_x = 3.0
  vim.g.neovide_floating_blur_amount_y = 3.0
  vim.g.neovide_transparency = 1.0
  vim.g.pumblend = 30

  vim.api.nvim_create_autocmd("WinEnter", {
    group = vim.api.nvim_create_augroup("Setup transparency", {}),
    pattern = "*",
    callback = function()
      vim.wo.winblend = 30
    end
  })
end

return M
