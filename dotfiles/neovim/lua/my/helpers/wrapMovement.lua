local M = {}

local function swap(key)
  vim.keymap.set("nv", key, "g" .. key, { buffer = true })
  vim.keymap.set("nv", "g" .. key, key, { buffer = true })
end

-- Same as swap, but the key is aprt of an arpeggio chord
local function swapArpeggio(key)
  vim.keymap.set("nv", "<Plug>(arpeggio-default:" .. key .. ")", "g" .. key, { buffer = true })
  vim.keymap.set("nv", "g" .. key, key, { buffer = true })
end

function M.setup()
  swapArpeggio("j")
  swap("k")
  swap("0")
  swap("$")
end

return M
