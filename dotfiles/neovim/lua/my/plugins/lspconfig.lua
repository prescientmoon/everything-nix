local M = {}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "tsserver", "purescriptls" }

function M.map(buf, mode, lhs, rhs, opts)
  local options = { noremap=true, silent=true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  map(buf, mode, lhs, rhs, options)
end

function on_attach(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Go to declaration / definition / implementation
    map(bufnr, "n", 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    map(bufnr, "n", 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')

    -- Hover
    map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    map(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

    -- Workspace stuff
    map(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
    map(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
    map(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

    -- Code actions
    map(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    map(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    map(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    map(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

function M.setup()
    for _, lsp in pairs(servers) do
        require('lspconfig')[lsp].setup {
            on_attach = on_attach,
            flags = {
                debounce_text_changes = 150, -- This will be the default in neovim 0.7+
            }
        }
    end
end

return M