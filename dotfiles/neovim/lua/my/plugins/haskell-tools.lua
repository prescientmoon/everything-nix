local lspconfig = require("my.plugins.lspconfig")
local M = {
  "mrcjkb/haskell-tools.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  version = "^2",
  ft = { "haskell", "lhaskell", "cabal", "cabalproject" },
}

function M.config()
  vim.g.haskell_tools = {
    hls = {
      on_attach = lspconfig.on_attach,
      settings = {
        haskell = {
          formattingProvider = "fourmolu",
          -- This seems to work better with custom preludes
          -- See this issue https://github.com/fourmolu/fourmolu/issues/357
          plugin = { fourmolu = { config = { external = true } } },
        },
      },
    },
    tools = {
      hover = {
        enable = false,
      },
    },
  }
end

return M
