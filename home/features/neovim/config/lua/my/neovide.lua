local M = {}

function M.setup()
  local default_length = 0.04
  -- vim.g.neovide_floating_blur_amount_x = 10.0
  -- vim.g.neovide_floating_blur_amount_y = 10.0
  vim.g.neovide_transparency = require("nix.theme").opacity.applications
  -- vim.g.transparency = 0.6
  -- vim.g.pumblend = 0
  vim.g.neovide_cursor_animation_length = default_length
  vim.g.neovide_cursor_animate_in_insert_mode = false
end

return M
