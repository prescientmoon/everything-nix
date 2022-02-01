local cmd = vim.cmd
local M = {}

-- Command for formatting lua code
local formatLua = "lua-format -i --no-keep-simple-function-one-line --no-break-after-operator --column-limit=150 --break-after-table-lb"

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
    tsserver = {settings = {}, cmd = nil},
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
        settings = {purescript = {censorWarnings = {"UnusedName", "ShadowedName", "UserDefinedWarning"}, formatter = "purs-tidy"}},
        cmd = nil
    },
    rnix = {settings = {}, cmd = nil}
}

local function map(buf, mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, options)
end

local function on_attach(client, bufnr)
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
    -- Setup basic language servers
    for lsp, details in pairs(servers) do
        require('lspconfig')[lsp].setup {
            on_attach = on_attach,
            settings = details.settings, -- Specific per-language settings
            flags = {
                debounce_text_changes = 150 -- This will be the default in neovim 0.7+
            },
            cmd = details.cmd
        }
    end

    local efmLanguages = {
        typescript = {
            formatCommand = 'prettierd "${INPUT}"',
            formatStdin = true,
            env = {string.format('PRETTIERD_DEFAULT_CONFIG=%s', vim.fn.expand('~/.config/nvim/utils/linter-config/.prettierrc.json'))}
        },
        lua = {{formatCommand = formatLua, formatStdin = true}}
    }

    -- Setup auto-formatting
    require"lspconfig".efm.setup {
        init_options = {documentFormatting = true},
        filetypes = {"lua", "ts", "js", "tsx", "jsx"},
        settings = {rootMarkers = {".git/"}, languages = efmLanguages}
    }

    local autoFormatOn = {lua = 100, purs = 1000, nix = 100, js = 100, ts = 100, tsx = 100, jsx = 100}

    -- Auto format
    for extension, timeout in pairs(autoFormatOn) do
        -- I wonder if this could be done in a single glob pattern
        cmd("autocmd BufWritePre *." .. extension .. " lua vim.lsp.buf.formatting_sync(nil, " .. timeout .. ")")
    end
end

return M
