local M = {}

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
    return { noremap = true, silent = true, desc = desc, buffer = true }
  end

  local nmap = function(from, to, desc)
    vim.keymap.set("n", from, to, opts(desc))
  end
  -- }}}
  -- {{{ Go to declaration / definition / implementation
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
  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>f", format, "[F]ormat")
  nmap("<leader>c", vim.lsp.buf.code_action, "[C]ode actions")

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
  tsserver = {
    on_attach = function(client, bufnr)
      -- We handle formatting using null-ls and prettierd
      client.server_capabilities.documentFormattingProvider = false
      M.on_attach(client, bufnr)
    end,
  },
  dhall_lsp_server = {},
  purescriptls = {
    settings = {
      purescript = {
        censorWarnings = { "UnusedName", "ShadowedName", "UserDefinedWarning" },
        formatter = "purs-tidy",
      },
    },
  },
  hls = {
    haskell = {
      -- set formatter
      formattingProvider = "ormolu",
    },
  },
  rnix = {},
  cssls = {},
  jsonls = {},
  rust_analyzer = {},
  -- teal_ls = {},
  sumneko_lua = {
    cmd = {
      "lua-language-server",
      "--logpath=/home/adrielus/.local/share/lua-language-server/log",
    },
  },
}
-- }}}

-- {{{ Capabilities
M.capabilities = require("cmp_nvim_lsp").default_capabilities()
-- Add folding capabilities
M.capabilities.textDocument.foldingRange =
  { dynamicRegistration = false, lineFoldingOnly = true }
-- }}}

function M.setup()
  -- {{{ Change on-hover borders
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
  -- }}}

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
      capabilities = M.capabilities,
    })
  end
end

return M
