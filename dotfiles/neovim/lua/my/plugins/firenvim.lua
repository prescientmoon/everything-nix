local env = require("my.helpers.env")
local K = require("my.keymaps")

local M = {
  "glacambre/firenvim", -- vim inside chrome
  lazy = false,
  cond = env.firenvim.active(),
}

function M.config()
  vim.g.firenvim_config = {
    localSettings = {
      [".*"] = {
        filename = "/tmp/firenvim_{hostname}_{pathname}_{selector}_{timestamp}.{extension}",
      },
    },
  }

  K.nmap("<C-e>", function()
    vim.opt.lines = 100
  end, "Expand the neovim window!")

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "firenvim_localhost_notebooks*.txt" },
    callback = function()
      vim.opt.filetype = "markdown"
    end,
  })

  -- Disable status line
  vim.opt.laststatus = 0
end

return M
