local env = require("my.helpers.env")

local M = {
  "glepnir/dashboard-nvim",
  lazy = false,
  cond = env.vscode.not_active() and env.firenvim.not_active(),
}

function M.config()
  local db = require("dashboard")
  db.custom_header = {}
end

return M
