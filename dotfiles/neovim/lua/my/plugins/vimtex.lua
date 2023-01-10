local M = {
  "lervag/vimtex", -- latex support
  ft = "tex",
  enabled = false
}

function M.config()
  vim.g.vimtex_view_method = "zathura"
  vim.g.Tex_DefaultTargetFormat = "pdf"
  vim.g.vimtex_compiler_latexmk = {
    options = {
      "-pdf",
      "-shell-escape",
      "-verbose",
      "-file-line-error",
      "-synctex=1",
      "-interaction=nonstopmode",
    },
  }

  vim.g.vimtex_fold_enabled = 0
  vim.g.vimtex_imaps_enabled = 0
  vim.g.vimtex_syntax_conceal_disable = 1
end

return M
