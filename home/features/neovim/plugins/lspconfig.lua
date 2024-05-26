---@diagnostic disable: missing-fields
local M = {}

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
function M.config()
  local lspconfig = require("lspconfig")

  -- {{{ General server config
  ---@type lspconfig.options
  local servers = {
    -- {{{ Typescript
    tsserver = {
      on_attach = function(client)
        -- We handle formatting using null-ls and prettierd
        client.server_capabilities.documentFormattingProvider = false
      end,
    },
    -- }}}
    -- {{{ Purescript
    purescriptls = {
      root_dir = lspconfig.util.root_pattern("spago.yaml"),
      settings = {
        purescript = {
          censorWarnings = {
            "UnusedName",
            "ShadowedName",
            "UserDefinedWarning",
          },
          formatter = "purs-tidy",
        },
      },
    },
    -- }}}
    -- {{{ Lua
    lua_ls = {
      settings = {
        Lua = {
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
              -- Required for syntax highlighting inside the generated pdf apparently
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
    cssls = {},
    jsonls = {},
    dhall_lsp_server = {},
    typst_lsp = {
      exportPdf = "onType",
    },
    elmls = {},
    csharp_ls = {},
  }
  -- }}}

  local capabilities = M.capabilities()
  for lsp, details in pairs(servers) do
    details.capabilities = capabilities
    lspconfig[lsp].setup(details)
  end
end
--}}}

return M
