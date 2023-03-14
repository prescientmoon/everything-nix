local M = {
  -- keybinds where you only hit the head once
  "anuvyklack/hydra.nvim",
  dependencies = {
    "jbyuki/venn.nvim", -- draw ascii diagrams
    "mrjones2014/smart-splits.nvim", -- the name says it all
  },
  keys = { "<C-w>", "<leader>v" },
  event = "VeryLazy",
}

local venn_hint = [[
 Arrow^^^^^^   Select region with <C-v> 
 ^ ^ _K_ ^ ^   _f_: surround it with box
 _H_ ^ ^ _L_
 ^ ^ _J_ ^ ^                      _<Esc>_
]]

local window_hint = [[
 ^^^^^^^^^^^^     Move      ^^    Size   ^^   ^^     Split
 ^^^^^^^^^^^^-------------  ^^-----------^^   ^^---------------
 ^ ^ _k_ ^ ^  ^ ^ _K_ ^ ^   ^   _<C-k>_   ^   _s_: horizontally 
 _h_ ^ ^ _l_  _H_ ^ ^ _L_   _<C-h>_ _<C-l>_   _v_: vertically
 ^ ^ _j_ ^ ^  ^ ^ _J_ ^ ^   ^   _<C-j>_   ^   _q_: close
 focus^^^^^^  window^^^^^^  ^_=_: equalize^   _o_: close remaining
]]

function M.config()
  local Hydra = require("hydra")
  local pcmd = require("hydra.keymap-util").pcmd
  local splits = require("smart-splits")

  Hydra({
    name = "Draw Diagram",
    hint = venn_hint,
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        border = "rounded",
      },
      on_enter = function()
        vim.o.virtualedit = "all"
      end,
    },
    mode = "n",
    body = "<leader>v",
    heads = {
      { "H", "<C-v>h:VBox<CR>" },
      { "J", "<C-v>j:VBox<CR>" },
      { "K", "<C-v>k:VBox<CR>" },
      { "L", "<C-v>l:VBox<CR>" },
      { "f", ":VBox<CR>", { mode = "v" } },
      { "<Esc>", nil, { exit = true } },
    },
  })

  vim.keymap.set("n", "<C-w>", "<Nop>")

  Hydra({
    name = "Windows",
    hint = window_hint,
    config = {
      invoke_on_body = true,
      hint = {
        border = "rounded",
        offset = -1,
      },
    },
    mode = "n",
    body = "<C-w>",
    heads = {
      { "h", "<C-w>h" },
      { "j", "<C-w>j" },
      { "k", "<C-w>k" },
      { "l", "<C-w>l" },

      { "H", "<C-w>H" },
      { "J", "<C-w>J" },
      { "K", "<C-w>K" },
      { "L", "<C-w>L" },

      {
        "<C-h>",
        function()
          splits.resize_left(2)
        end,
      },
      {
        "<C-j>",
        function()
          splits.resize_down(2)
        end,
      },
      {
        "<C-k>",
        function()
          splits.resize_up(2)
        end,
      },
      {
        "<C-l>",
        function()
          splits.resize_right(2)
        end,
      },
      { "=", "<C-w>=", { desc = "equalize" } },
      { "s", pcmd("split", "E36") },
      { "v", pcmd("vsplit", "E36") },
      { "o", "<C-w>o", { exit = true, desc = "remain only" } },
      { "q", pcmd("close", "E444"), { desc = "close window" } },
    },
  })
end

return M
