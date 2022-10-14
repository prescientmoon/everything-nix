local mind = require("mind")
local M = {}

function M.setup()
  mind.setup({
    persistence = {
      state_path = "~/Mind/mind.json",
      data_dir = "~/Mind/data"
    },
    ui = {
      width = 50
    }
  })

  vim.keymap.set("n", "<leader>m", function()
    local buffers = vim.api.nvim_list_bufs()
    local should_open = true

    for _, buf in pairs(buffers) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "mind" then
        should_open = false
        vim.cmd("bd " .. buf)
      end
    end

    if should_open then
      mind.open_main()
    end
  end, { desc = "Toggle mind panel" })
end

return M
