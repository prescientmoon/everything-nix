local env = require("my.helpers.env")

local M = {
  "glacambre/firenvim", -- vim inside chrome
  lazy = false,
  cond = env.firenvim.active(),
}

function M.setup()
  vim.g.firenvim_config = {
    localSettings = {
      [".*"] = {
        filename = "/tmp/firenvim_{hostname}_{pathname%10}_{timestamp%32}.{extension}",
      },
    },
  }
end

return M
