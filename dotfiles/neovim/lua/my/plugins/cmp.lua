local M = {}

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and
      vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
        col)
      :match('%s') == nil
end

function M.setup()
  local cmp = require("cmp")
  local lspkind = require('lspkind')
  -- local luasnip = require("luasnip")

  local options = {
    window = {
      completion = {
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        col_offset = -3,
        side_padding = 0,
      },
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local kind = lspkind.cmp_format({ mode = "symbol", maxwidth = 50
          , symbol_map = {
            Text = "."
          }
        })(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })

        kind.kind = " " .. strings[1] .. " "
        kind.menu = ""

        return kind
      end,
    },
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end
    },
    mapping = {
      ["<C-d>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-s>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' }, -- lsp completion
      { name = 'luasnip' }, -- snippets
      { name = 'omni' } -- omnifunc
    }, { { name = 'buffer' } })
  }

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })
end

return M
