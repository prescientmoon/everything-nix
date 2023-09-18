local M = {
  "jbyuki/venn.nvim", -- draw ascii diagrams
  dependencies = {
    "anuvyklack/hydra.nvim",
  },
  keys = { "<leader>V" },
}

local venn_hint_old = [[
 ^^^Draw arrow^^^   Select region with <C-v>
 ^ ^ _K_ ^ ^   _f_: surround it with box
 _H_ ^ ^ _L_
 ^ ^ _J_ ^ ^                      _<Esc>_
]]

local H = require("my.plugins.hydra").hint

local venn_hint = H.concat_many_h({
  H.add_title("Draw arrows", H.directional("H", "J", "K", "L", 3)),
  H.add_title(
    "Actions",
    H.concat_many_w({
      H.concat_h("<C-v>", ": select region"),
      H.concat_h(H.pad_right(H.highlight("f"), 5), ": surround with box"),
      H.concat_h(H.pad_right(H.highlight("<Esc>"), 5), ": quit"),
    }, { justify = "left" })
  ),
}, 3).value

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
