local M = {}
local luasnip = require("luasnip")

local function reload()
  require("luasnip.loaders.from_vscode").lazy_load()
end

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

  vim.keymap.set("n", "<leader>rs", reload, {
    desc = "Reload luasnip snippets"
  })

  reload()
end

return M
