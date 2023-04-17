local K = require("my.keymaps")
local lspconfig = require("my.plugins.lspconfig")

local M = {
  "simrat39/rust-tools.nvim",
  config = function()
    require("rust-tools").setup({
      server = {
        on_attach = lspconfig.on_attach,
      },
    })

    K.nmap(
      "<leader>lc",
      "<cmd>RustOpenCargo<cr>",
      "Open [c]argo.toml",
      true,
      true
    )
  end,
}

return M
