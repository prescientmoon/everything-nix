vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = vim.api.nvim_create_augroup("Detect hkf", {}),
  pattern = "*.hkf",
  callback = function()
    vim.opt.filetype = "hkf"
  end
})
