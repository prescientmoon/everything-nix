local M = {}

function M.setup()
  local iron = require("iron.core")

  iron.setup {
    config = {
      -- Your repl definitions come here
      repl_definition = {},
      -- How the repl window will be displayed
      -- See below for more information
      repl_open_cmd = require('iron.view').right(40)
    },
    -- Iron doesn't set keymaps by default anymore.
    -- You can set them here or manually add keymaps to the functions in iron.core
    keymaps = {
      send_motion = "<space>isc",
      visual_send = "<space>is",
      send_file = "<space>isf",
      send_line = "<space>isl",
      send_mark = "<space>ism",
      mark_motion = "<space>imc",
      mark_visual = "<space>imc",
      remove_mark = "<space>imd",
      cr = "<space>is<cr>",
      interrupt = "<space>is<space>",
      exit = "<space>isq",
      clear = "<space>isr"
    },
    -- If the highlight is on, you can change how it looks
    -- For the available options, check nvim_set_hl
    highlight = { italic = true },
    ignore_blank_lines = true -- ignore blank lines when sending visual select lines
  }

  -- iron also has a list of commands, see :h iron-commands for all available commands
  vim.keymap.set('n', '<space>iss', '<cmd>IronRepl<cr>')
  vim.keymap.set('n', '<space>ir', '<cmd>IronRestart<cr>')
  vim.keymap.set('n', '<space>if', '<cmd>IronFocus<cr>')
  vim.keymap.set('n', '<space>ih', '<cmd>IronHide<cr>')

  local status, wk = pcall(require, "which-key")

  if status then wk.register({ ["<leader>i"] = { name = "[I]ron repl commands", s = {name = "[s]end"}, m = "[m]ark" } }) end
end

return M
