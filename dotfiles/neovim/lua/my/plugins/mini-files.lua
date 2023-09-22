local K = require("my.keymaps")
local env = require("my.helpers.env")

local M = {
  "echasnovski/mini.files",
  version = "main",
  event = "VeryLazy",
  cond = env.vscode.not_active() and env.firenvim.not_active(),
}

function M.config()
  local files = require("mini.files")

  files.setup({
    windows = {
      preview = false,
    },
    mappings = {
      go_in_plus = "<cr>",
    },
  })

  K.nmap("<C-S-F>", function()
    if not files.close() then
      files.open(vim.api.nvim_buf_get_name(0))
      files.reveal_cwd()
    end
  end, "[S]earch [F]iles")
end

return M
