local helpers = require("my.helpers")
local arpeggio = require("my.plugins.arpeggio")

local M = {}

-- {{{ Helpers
-- Performs a basic move operation
function M.move(from, to, opts)
  vim.keymap.set("n", to, from, opts)
  vim.keymap.set("n", from, "<Nop>")
end

function M.delimitedTextobject(from, to, name, perhapsOpts)
  local opts = helpers.mergeTables(perhapsOpts or {}, { desc = name })

  vim.keymap.set({ "v", "o" }, "i" .. from, "i" .. to, opts)
  vim.keymap.set({ "v", "o" }, "a" .. from, "a" .. to, opts)
end
-- }}}

function M.setup()
  -- {{{ Free up q and Q
  M.move("q", "yq", { desc = "Record macro" })
  M.move("Q", "yQ")
  -- }}}
  -- {{{ Easier access to C^
  M.move("<C-^>", "<Leader>a", { desc = "Go to previous file" })
  -- }}}
  -- {{{ Quit current buffer / all buffers
  vim.keymap.set({ "n", "v" }, "<leader>q", function()
    local buf = vim.api.nvim_win_get_buf(0)

    -- Only save if file is writable
    if vim.bo[buf].modifiable and not vim.bo[buf].readonly then vim.cmd [[write]] end

    vim.cmd "q"
  end, { desc = "Quit current buffer" })

  vim.keymap.set("n", "Q", ":wqa<cr>", { desc = "Save all files and quit" })
  -- }}}
  -- {{{ Replace word in file
  vim.keymap.set("n", "<leader>rw", ":%s/<C-r><C-w>/", { desc = "Replace word in file" })
  -- }}}
  -- {{{ Text objects
  M.delimitedTextobject("q", '"', "quotes")
  M.delimitedTextobject("a", "'", "'")
  M.delimitedTextobject("r", "[", "square brackets")
  -- }}}
  -- {{{Diagnostic keymaps
  do
    local opts = function(desc)
      return { noremap = true, silent = true, desc = desc }
    end

    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts("Goto previous diagnostic"))
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts("Goto next diagnostic"))
    vim.keymap.set('n', 'J', vim.diagnostic.open_float, opts("Open current diagnostic"))
    vim.keymap.set('n', '<leader>J', vim.diagnostic.setloclist, opts("Set diagnostics loclist"))
  end
  -- }}}
  -- {{{ Chords
  if arpeggio ~= nil then
    arpeggio.chordSilent("n", "ji", ":silent :write<cr>") -- Saving
    arpeggio.chord("i", "jk", "<Esc>") -- Remap Esc to jk
    arpeggio.chord("nv", "cp", "\"+") -- Press cp to use the global clipboard
  end
  -- }}}
  -- {{{ Set up which-key structure
  local status, wk = pcall(require, "which-key")

  if status then
    wk.register({
      ["<leader>"] = {
        f = { name = "Files" },
        g = { name = "Go to" },
        r = { name = "Rename / Replace / Reload" },
        l = { name = "Local" },
        v = "which_key_ignore"
      }
    })
  end
  -- }}}

  return M
end

return M
