local helpers = require("my.helpers")
local arpeggio = require("my.plugins.arpeggio")

local M = {}

local function map(mode, lhs, rhs, opts)
  if string.len(mode) > 1 then
    for i = 1, #mode do
      local c = mode:sub(i, i)
      map(c, lhs, rhs, opts)
    end
  else
    local options = helpers.mergeTables(opts, { noremap = true })
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end
end

function M.mapSilent(mode, lhs, rhs, opts)
  local options = helpers.mergeTables(opts, { silent = true })
  map(mode, lhs, rhs, options)
end

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

function M.setup()
  M.move("q", "yq", { desc = "Record macro" })
  M.move("Q", "yQ")
  M.move("<C-^>", "<Leader>a", { desc = "Go to previous file" })

  vim.keymap.set({ "n", "v" }, "qn", function()
    local buf = vim.api.nvim_win_get_buf(0)

    -- Only save if file is writable
    if vim.bo[buf].modifiable and not vim.bo[buf].readonly then
      vim.cmd [[write]]
    end

    vim.cmd "q"
  end, { desc = "Quit current buffer" })

  vim.keymap.set("n", "Q", ":wqa<cr>", { desc = "Save all files and quit" })
  vim.keymap.set("n", "<leader>rw", ":%s/<C-r><C-w>/", {
    desc = "Replace word in file"
  })

  M.delimitedTextobject("q", '"', "quotes")
  M.delimitedTextobject("a", "'", "'")
  M.delimitedTextobject("r", "[", "square brackets")

  -- Create chords
  if arpeggio ~= nil then
    arpeggio.chordSilent("n", "ji", ":silent :write<cr>") -- Saving
    arpeggio.chord("i", "jk", "<Esc>") -- Remap Esc to jk
    arpeggio.chord("nv", "cp", "\"+") -- Press cp to use the global clipboard
  end

  local status, wk = pcall(require, "which-key")

  if status then
    wk.register({
      ["<leader>"] = {
        f = {
          name = "Files"
        },
        g = {
          name = "Go to"
        },
        r = {
          name = "Rename / Replace"
        },
        ["<leader>"] = {
          name = "Easymotion"
        },
        v = "which_key_ignore"
      }
    })
  end

  return M
end

return M
