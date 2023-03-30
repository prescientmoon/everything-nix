local helpers = require("my.helpers")
local env = require("my.helpers.env")

local lspconfig = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "folke/neoconf.nvim",
    {
      "folke/neodev.nvim",
      config = true,
    },
    "hrsh7th/cmp-nvim-lsp",
  },
  cond = env.vscode.not_active(),
}

local M = {
  lspconfig,
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {
      input_buffer_type = "dressing",
    },
    dependencies = {
      "dressing.nvim",
    },
    cond = env.vscode.not_active(),
  },
}

function M.on_attach(client, bufnr)
  -- {{{ Auto format
  local function format()
    vim.lsp.buf.format({ async = false, bufnr = bufnr })
  end

  if false and client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting", { clear = false }),
      buffer = bufnr,
      callback = format,
    })
  end
  -- }}}
  -- {{{ Keymap helpers
  local opts = function(desc)
    return { noremap = true, silent = true, desc = desc, buffer = bufnr }
  end

  local nmap = function(from, to, desc)
    vim.keymap.set("n", from, to, opts(desc))
  end
  -- }}}
  -- {{{ Go to declaration / references / implementation
  nmap("gd", vim.lsp.buf.definition, "[G]o to [d]efinition")
  nmap("gi", vim.lsp.buf.implementation, "[G]o to [i]mplementation")
  nmap("gr", vim.lsp.buf.references, "[G]o to [r]eferences")
  -- }}}
  -- {{{ Hover
  -- Note: diagnostics are already covered in keymaps.lua
  nmap("K", vim.lsp.buf.hover, "Hover")
  nmap("L", vim.lsp.buf.signature_help, "Signature help")
  -- }}}
  -- {{{ Code actions
  nmap("<leader>c", vim.lsp.buf.code_action, "[C]ode actions")
  nmap("<leader>F", format, "[F]ormat")
  nmap("<leader>li", "<cmd>LspInfo<cr>", "[L]sp [i]nfo")

  vim.keymap.set("n", "<leader>rn", function()
    return ":IncRename " .. vim.fn.expand("<cword>")
  end, helpers.mergeTables(opts("[R]e[n]ame"), { expr = true }))

  vim.keymap.set(
    "v",
    "<leader>c",
    ":'<,'> lua vim.lsp.buf.range_code_action()",
    opts("[C]ode actions")
  )
  -- }}}
  -- {{{ Workspace stuff
  nmap(
    "<leader>wa",
    vim.lsp.buf.add_workspace_folder,
    "[W]orkspace [A]dd Folder"
  )
  nmap(
    "<leader>wr",
    vim.lsp.buf.remove_workspace_folder,
    "[W]orkspace [R]emove Folder"
  )
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")
  -- }}}
end

-- {{{ General server config
---@type lspconfig.options
local servers = {
  -- {{{ Typescript
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
      purescript = {
        censorWarnings = { "UnusedName", "ShadowedName", "UserDefinedWarning" },
        formatter = "purs-tidy",
      },
    },
  },
  -- }}}
  -- {{{ Haskell
  hls = {
    haskell = {
      -- set formatter
      formattingProvider = "ormolu",
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
      Lua = {
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
      },
    },
  },
  -- }}}
  rnix = {},
  cssls = {},
  jsonls = {},
  rust_analyzer = {},
  dhall_lsp_server = {},
  -- pylsp = {},
  -- pyright = {},
}
-- }}}
-- {{{ Capabilities
M.capabilities = function()
  -- require("lazy").load({ plugins = "hrsh7th/cmp-nvim-lsp" })
  local c = require("cmp_nvim_lsp").default_capabilities()
  -- Add folding capabilities
  c.textDocument.foldingRange =
    { dynamicRegistration = false, lineFoldingOnly = true }
  return c
end
-- }}}
-- {{{ Nice diagnostic icons
-- See https://github.com/folke/dot/blob/master/config/nvim/lua/config/plugins/lsp/diagnostics.lua
local function diagnostics_icons()
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end
end

--}}}
-- {{{ Main config function
function lspconfig.config()
  diagnostics_icons()
  -- -- {{{ Change on-hover borders
  -- vim.lsp.handlers["textDocument/hover"] =
  --   vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
  -- vim.lsp.handlers["textDocument/signatureHelp"] =
  --   vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
  -- -- }}}

  local capabilities = M.capabilities()
  -- Setup basic language servers
  for lsp, details in pairs(servers) do
    if details.on_attach == nil then
      -- Default setting for on_attach
      details.on_attach = M.on_attach
    end

    require("lspconfig")[lsp].setup({
      on_attach = details.on_attach,
      settings = details.settings, -- Specific per-language settings
      flags = {
        debounce_text_changes = 150, -- This will be the default in neovim 0.7+
      },
      cmd = details.cmd,
      capabilities = capabilities,
    })
  end
end

--}}}

return M
