local env = require("my.helpers.env")

local M = {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  cond = env.vscode.not_active(),
}

function M.config()
  require("lualine").setup({
    options = {
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      theme = "auto",
    },
    sections = {
      lualine_a = { "branch" },
      lualine_b = { "filename" },
      lualine_c = { "filetype" },
      lualine_x = { "diagnostics" },
      lualine_y = {},
      lualine_z = {},
    },
    -- Integration with other plugins
    extensions = { "nvim-tree" },
  })
end

return M
