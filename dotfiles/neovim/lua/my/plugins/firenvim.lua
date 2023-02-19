local env = require("my.helpers.env")

local M = {
  "glacambre/firenvim", -- vim inside chrome
  lazy = false,
  cond = env.firenvim.active(),
}

function M.config()
  vim.g.firenvim_config = {
    localSettings = {
      [".*"] = {
        filename = "/tmp/firenvim_{hostname}_{pathname%10}_{timestamp%32}.{extension}",
      },
    },
  }

  -- Disable status line
  vim.opt.laststatus = 0
end

return M
