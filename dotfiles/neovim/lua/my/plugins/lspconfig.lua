local M = {}

local function map(buf, mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, options)
end

function M.on_attach(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    if client.resolved_capabilities.document_formatting then
        vim.cmd([[
            augroup LspFormatting
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
            augroup END
            ]])
    end

    -- Go to declaration / definition / implementation
    map(bufnr, "n", 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    map(bufnr, "n", 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    map(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')

    -- Hover
    map(bufnr, 'n', 'J',
        "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
    map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    map(bufnr, 'n', 'L', '<cmd>lua vim.lsp.buf.signature_help()<CR>')

    -- Workspace stuff
    map(bufnr, 'n', '<leader>wa',
        '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
    map(bufnr, 'n', '<leader>wr',
        '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
    map(bufnr, 'n', '<leader>wl',
        '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')

    -- Code actions
    map(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
    map(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    -- map(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    map(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
    map(bufnr, 'n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
end

local function on_attach_typescript(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    M.on_attach(client, bufnr)
end

-- General server config
local servers = {
    tsserver = {on_attach = on_attach_typescript},
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
                    globals = {'vim'}
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true)
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = {enable = false}
            }
        },
        cmd = {"lua-language-server"}
    },
    purescriptls = {
        settings = {
            purescript = {
                censorWarnings = {
                    "UnusedName", "ShadowedName", "UserDefinedWarning"
                },
                formatter = "purs-tidy"
            }
        }
    },
    rnix = {},
    hls = {
        haskell = {
            -- set formatter
            formattingProvider = "ormolu"
        }
    }
    -- agda = {}, Haven't gotten this one to work yet
}

function M.setup()
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                         .protocol
                                                                         .make_client_capabilities())

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
            capabilities = capabilities
        }
    end
end

return M
