local M = {}

function M.setup()
  vim.opt.runtimepath:append(vim.g.nix_extra_runtime)
  local tempest = require("my.tempest")
  local nix = require("nix")
  -- Import my other files
  tempest.configureMany(nix.pre)
  require("my.keymaps").setup()
  require("my.lazy").setup()
  tempest.configureMany(nix.post)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "tex",
    group = vim.api.nvim_create_augroup("luasnip-latex-snippets", {}),
    once = true,
    callback = function()
      require("my.snippets.tex").setup()
    end,
  })
end

return M
