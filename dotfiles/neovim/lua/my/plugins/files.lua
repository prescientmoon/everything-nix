local K = require("my.keymaps")

local M = {
  "echasnovski/mini.files",
  version = "main",
  keys = { "<C-S-F>" },
}

function M.config()
  local files = require("mini.files")

  files.setup({
    windows = {
      preview = true,
    },
    mappings = {
      reveal_cwd = "R",
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
