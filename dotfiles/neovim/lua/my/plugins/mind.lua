local M = {
  "phaazon/mind.nvim", -- Organize shit as trees
  cmd = "MindOpenMain",
}

function M.init()
  vim.keymap.set(
    "n",
    "<leader>m",
    "<cmd>MindOpenMain<cr>",
    { desc = "[M]ind panel" }
  )
end

function M.config()
  local mind = require("mind")

  mind.setup({
    persistence = {
      state_path = "~/Projects/Mind/mind.json",
      data_dir = "~/Mind/data",
    },
    ui = {
      width = 50,
    },
  })
end

return M
