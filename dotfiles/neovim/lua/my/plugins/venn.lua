local M = {
  "jbyuki/venn.nvim", -- draw ascii diagrams
  dependencies = {
    "anuvyklack/hydra.nvim",
  },
  keys = { "<leader>V" },
}

local venn_hint = [[
 ^^^Arrow^^^   Select region with <C-v>
 ^ ^ _K_ ^ ^   _f_: surround it with box
 _H_ ^ ^ _L_
 ^ ^ _J_ ^ ^                      _<Esc>_
]]

function M.config()
  local Hydra = require("hydra")

  Hydra({
    name = "Draw Diagram",
    hint = venn_hint,
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        border = "single",
      },
      on_enter = function()
        vim.o.virtualedit = "all"
      end,
    },
    mode = "n",
    desc = "[V]enn mode",
    body = "<leader>V",
    heads = {
      { "H", "<C-v>h:VBox<CR>" },
      { "J", "<C-v>j:VBox<CR>" },
      { "K", "<C-v>k:VBox<CR>" },
      { "L", "<C-v>l:VBox<CR>" },
      { "f", ":VBox<CR>", { mode = "v" } },
      { "<Esc>", nil, { exit = true } },
    },
  })
end

function M.init()
  require("which-key").register({
    ["<leader>V"] = { name = "[V]enn mode" },
  })
end

return M
