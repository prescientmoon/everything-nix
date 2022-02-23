local M = {}

local function has_words_before ()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

function M.setup()
    local cmp = require("cmp")
    local lspkind = require('lspkind')
    local options = {
        formatting = {format = lspkind.cmp_format()},
        mapping = {
            ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
            -- ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
            ['<C-y>'] = cmp.config.disable,
            ['<C-e>'] = cmp.mapping({i = cmp.mapping.abort(), c = cmp.mapping.close()}),
            ['<CR>'] = cmp.mapping.confirm({select = true}),
	    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
            ['<C-Space>'] = cmp.mapping.confirm {behavior = cmp.ConfirmBehavior.Insert, select = true},
            ['<Tab>'] = function(fallback)
                if not cmp.select_next_item() then
                    if vim.bo.buftype ~= 'prompt' and has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end
            end,
            ['<S-Tab>'] = function(fallback)
                if not cmp.select_prev_item() then
                    if vim.bo.buftype ~= 'prompt' and has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end
            end,
        },
        sources = cmp.config.sources({{name = 'nvim_lsp'}}, {{name = 'buffer'}})
    }

    cmp.setup(options)

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {sources = {{name = 'buffer'}}})

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {sources = cmp.config.sources({{name = 'path'}}, {{name = 'cmdline'}})})
end

return M
