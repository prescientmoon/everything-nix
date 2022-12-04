local M = {}

function M.on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting", {}),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end
    })
  end

  local opts = function(desc)
    return { noremap = true, silent = true, desc = desc }
  end

  -- Go to declaration / definition / implementation
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("Go to references"))

  -- Hover
  vim.keymap.set("n", "J", vim.diagnostic.open_float, opts("Show diagnostic"))
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover"))
  vim.keymap.set("n", "L", vim.lsp.buf.signature_help, opts("Signature help"))

  -- Code actions
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))
  vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action, opts("Code actions"))
  vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts("Format"))
end

-- General server config
local servers = {
  tsserver = {
    on_attach = function(client, bufnr)
      -- We handle formatting using null-ls and prettierd
      client.server_capabilities.documentFormattingProvider = false
      M.on_attach(client, bufnr)
    end
  },
  dhall_lsp_server = {},
  sumneko_lua = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' }
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true)
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = { enable = false }
      }
    },
    cmd = { "lua-language-server" }
  },
  purescriptls = {
    settings = {
      purescript = {
        censorWarnings = { "UnusedName", "ShadowedName", "UserDefinedWarning" },
        formatter = "purs-tidy"
      }
    }
  },
  hls = {
    haskell = {
      -- set formatter
      formattingProvider = "ormolu"
    }
  },
  rnix = {},
  cssls = {},
  rust_analyzer = {},
  -- texlab = {
  --   build = {
  --     executable = "tectonic",
  --     args = {
  --       "-X",
  --       "compile",
  --       "%f",
  --       "--synctex",
  --       "--keep-logs",
  --       "--keep-intermediates"
  --     }
  --   }
  -- },
  kotlin_language_server = {}
  -- agda = {}, Haven't gotten this one to work yet
}

M.capabilities = require('cmp_nvim_lsp').default_capabilities()

function M.setup()

  -- Setup basic language servers
  for lsp, details in pairs(servers) do
    if details.on_attach == nil then
      -- Default setting for on_attach
      details.on_attach = M.on_attach
    end

    require('lspconfig')[lsp].setup {
      on_attach = details.on_attach,
      settings = details.settings, -- Specific per-language settings
      flags = {
        debounce_text_changes = 150 -- This will be the default in neovim 0.7+
      },
      cmd = details.cmd,
      capabilities = M.capabilities
    }
  end
end

return M
