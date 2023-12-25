-- TODO: operator for wrapping motion with fold
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
---@param opts table|nil
function M.delimitedTextobject(from, to, name, opts)
  opts = opts or {}

  if opts.desc == nil then
    opts.desc = name
  end

  vim.keymap.set({ "v", "o" }, "i" .. from, "i" .. to, opts)
  vim.keymap.set({ "v", "o" }, "a" .. from, "a" .. to, opts)
end

---Helper to create a normal mode mapping and give it some description.
---@param from string
---@param to string|function
---@param desc string
---@param silent boolean|nil
---@param isLocal boolean|nil
function M.nmap(from, to, desc, silent, isLocal)
  if silent == nil then
    silent = true
  end

  if isLocal == nil then
    isLocal = false
  end

  vim.keymap.set(
    "n",
    from,
    to,
    { desc = desc, silent = silent, buffer = isLocal }
  )
end

-- }}}

function M.setup()
  -- {{{ Text objects
  M.delimitedTextobject("q", '"', "[q]uotes")
  M.delimitedTextobject("a", "'", "[a]postrophes")
  M.delimitedTextobject("r", "[", "squa[r]e brackets")
  -- }}}
end

return M
