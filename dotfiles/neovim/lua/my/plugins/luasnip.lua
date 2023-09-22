local env = require("my.helpers.env")

local M = {
  "L3MON4D3/LuaSnip", -- snippeting engine
  cond = env.vscode.not_active(),
}

local function reload()
  require("luasnip.loaders.from_vscode").lazy_load()
end

function M.config()
  local luasnip = require("luasnip")

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
    desc = "[R]eload [s]nippets",
  })

  reload()
end

return M
