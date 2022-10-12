local M = {}
local luasnip = require("luasnip")

function M.setup()
  vim.keymap.set("i", "<Tab>", function()
    if luasnip.jumpable(1) then
      return "<cmd>lua require('luasnip').jump(1)<cr>"
    else
      return "<Tab>"
    end
  end, { expr = true })
  vim.keymap.set("i", "<S-Tab>", function()
    luasnip.jump(-1)
  end)
end

return M
