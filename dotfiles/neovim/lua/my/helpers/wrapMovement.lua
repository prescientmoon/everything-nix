local M = {}

local function swap(key)
  vim.keymap.set({ "n", "v" }, key, "g" .. key, { buffer = true })
  vim.keymap.set({ "n", "v" }, "g" .. key, key, { buffer = true })
end

local function unswap(key)
  vim.keymap.del({ "n", "v" }, key)
  vim.keymap.del({ "n", "v" }, "g" .. key)
end

function M.enable()
  vim.opt.wrap = true

  swap("j")
  swap("k")
  swap("0")
  swap("$")
end

function M.disable()
  vim.opt.wrap = false

  unswap("j")
  unswap("k")
  unswap("0")
  unswap("$")
end

function M.toggle()
  if vim.opt.wrap == true then
    M.disable()
  else
    M.enable()
  end
end

return M
