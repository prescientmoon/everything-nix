local global = require("my.helpers").global

local M = {}

function M.setup()
  -- Viewer method
  vim.g.vimtex_view_method = "zathura"
  vim.g.Tex_DefaultTargetFormat = "pdf"
  vim.g.vimtex_fold_enabled = 1
  vim.g.vimtex_compiler_latexmk = {
    options = {
      "-pdf", "-shell-escape", "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode"
    }
  }
end

return M
