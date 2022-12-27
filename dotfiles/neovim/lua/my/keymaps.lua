local helpers = require("my.helpers")

local M = {}

-- {{{ Helpers
---Performs a basic move operation
---Moves a keybind to a different set of keys.
---Useful for moving built in keybinds out of the way.
---@param from string
---@param to string
---@param opts table|nil
function M.move(from, to, opts)
  vim.keymap.set("n", to, from, opts)
  vim.keymap.set("n", from, "<Nop>")
end

---Create a textobject defined by some delimiters
---@param from string
---@param to string
---@param name string
---@param perhapsOpts table|nil
function M.delimitedTextobject(from, to, name, perhapsOpts)
  local opts = helpers.mergeTables(perhapsOpts or {}, { desc = name })

  vim.keymap.set({ "v", "o" }, "i" .. from, "i" .. to, opts)
  vim.keymap.set({ "v", "o" }, "a" .. from, "a" .. to, opts)
end

---Helper to create a normal mode mapping and give it some description.
---@param from string
---@param to string|function
---@param desc string
---@param silent boolean|nil
function M.nmap(from, to, desc, silent)
  if silent == nil then
    silent = true
  end
  vim.keymap.set("n", from, to, { desc = desc })
end

-- }}}

function M.setup()
  -- {{{ Free up q and Q
  M.move("q", "yq", { desc = "Record macro" })
  M.move("Q", "yQ")
  -- }}}
  -- {{{ Easier access to <C-^>
  M.move("<C-^>", "<Leader>a", { desc = "[A]lternate file" })
  -- }}}
  -- {{{ Quit current buffer / all buffers
  vim.keymap.set({ "n", "v" }, "<leader>q", function()
    local buf = vim.api.nvim_win_get_buf(0)

    -- Only save if file is writable
    if vim.bo[buf].modifiable and not vim.bo[buf].readonly then
      vim.cmd([[write]])
    end

    vim.cmd("q")
  end, { desc = "[q]uit current buffer" })

  M.nmap("Q", ":wqa<cr>", "Save all files and [q]uit")
  -- }}}
  -- {{{ Replace word in file
  M.nmap("<leader>rw", ":%s/<C-r><C-w>/", "[R]eplace [w]ord in file")
  -- }}}
  -- {{{ Text objects
  M.delimitedTextobject("q", '"', "[q]uotes")
  M.delimitedTextobject("a", "'", "[a]postrophes")
  M.delimitedTextobject("r", "[", "squa[r]e brackets")
  -- }}}
  -- {{{Diagnostic keymaps
  M.nmap("[d", vim.diagnostic.goto_prev, "Goto previous [d]iagnostic")
  M.nmap("]d", vim.diagnostic.goto_next, "Goto next [d]iagnostic")
  M.nmap("J", vim.diagnostic.open_float, "Open current diagnostic")
  M.nmap("<leader>D", vim.diagnostic.setloclist, "[S]iagnostic loclist")
  -- }}}
  -- {{{ Chords (exit insert mode, save, clipboard)
  -- }}}
  -- {{{ Set up which-key structure
  local status, wk = pcall(require, "which-key")

  if status then
    wk.register({
      ["<leader>"] = {
        f = { name = "[F]iles" },
        g = { name = "[G]o to" },
        r = { name = "[R]ename / [R]eplace / [R]eload" },
        l = { name = "[L]ocal" },
        w = { name = "[W]orkspace" },
        v = "which_key_ignore",
      },
    })
  end
  -- }}}



vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "help",
    "man",
    "notify",
    "lspinfo"
  },
  callback = function(event)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "[q]uit current buffer" })
  end,
})

  return M
end

return M
