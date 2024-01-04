local runtime = require("my.tempest")

local lspconfig = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "neoconf",
    {
      "folke/neodev.nvim",
      config = true,
    },
  },
  cond = runtime.blacklist("vscode"),
}

local M = lspconfig

-- {{{ General server config
---@type lspconfig.options
---@diagnostic disable-next-line: missing-fields
local servers = {
  -- {{{ Typescript
  ---@diagnostic disable-next-line: missing-fields
  tsserver = {
    on_attach = function(client, bufnr)
      -- We handle formatting using null-ls and prettierd
      client.server_capabilities.documentFormattingProvider = false
      M.on_attach(client, bufnr)
    end,
  },
  -- }}}
  -- {{{ Purescript
  purescriptls = {
    settings = {
      ---@diagnostic disable-next-line: missing-fields
      purescript = {
        censorWarnings = { "UnusedName", "ShadowedName", "UserDefinedWarning" },
        formatter = "purs-tidy",
      },
    },
  },
  -- }}}
  -- {{{ Lua
  lua_ls = {
    cmd = {
      "lua-language-server",
      "--logpath=/home/adrielus/.local/share/lua-language-server/log",
    },
    settings = {
      ---@diagnostic disable-next-line: missing-fields
      Lua = {
        ---@diagnostic disable-next-line: missing-fields
        format = {
          enable = true,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  },
  -- }}}
  -- {{{ Latex
  texlab = {
    settings = {
      texlab = {
        build = {
          args = {
            -- Here by default:
            "-pdf",
            "-interaction=nonstopmode",
            "-synctex=1",
            "%f",
            -- Required for syntax highlighting inside the generated pdf aparently
            "-shell-escape",
          },
          executable = "latexmk",
          forwardSearchAfter = true,
          onSave = true,
        },
        chktex = {
          onOpenAndSave = true,
          onEdit = true,
        },
      },
    },
  },
  -- }}}
  -- {{{ Nix
  rnix = {},
  -- nil_ls = {},
  nixd = {},
  -- }}}
  ---@diagnostic disable-next-line: missing-fields
  cssls = {},
  ---@diagnostic disable-next-line: missing-fields
  jsonls = {},
  dhall_lsp_server = {},
  typst_lsp = {},
  ---@diagnostic disable-next-line: missing-fields
  elmls = {},
  -- {{{ Inactive
  -- pylsp = {},
  -- pyright = {},
  -- }}}
}
-- }}}
-- {{{ Capabilities
M.capabilities = function()
  local c = require("cmp_nvim_lsp").default_capabilities()
  -- Add folding capabilities
  c.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  return c
end
-- }}}
-- {{{ Main config function
function lspconfig.config()
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
  -- }}}

  local capabilities = M.capabilities()
  for lsp, details in pairs(servers) do
    details.capabilities = capabilities
    require("lspconfig")[lsp].setup(details)
  end
end
--}}}

return M
