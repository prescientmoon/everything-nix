local M = {}

local function swap(key)
  vim.keymap.set({ "n", "v" }, key, "g" .. key, { buffer = true })
  vim.keymap.set({ "n", "v" }, "g" .. key, key, { buffer = true })
end

function M.setup()
  swap("j")
  swap("k")
  swap("0")
  swap("$")
end

return M
