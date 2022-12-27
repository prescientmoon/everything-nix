local M = {
  -- work with brackets, quotes, tags, etc
  "tpope/vim-surround",
  event = "VeryLazy",
}

function M.config()
  vim.g.surround_113 = '"\r"'
  vim.g.surround_97 = "'\r'"
end

return M
