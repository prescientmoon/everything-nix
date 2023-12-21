local M = {}

function M.config()
  local cmp = require("cmp")
  local opts = {
    -- {{{ window
    window = {
      documentation = cmp.config.window.bordered(),
      completion = cmp.config.window.bordered({
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        col_offset = -3,
        side_padding = 0,
        completeopt = "menu,menuone,noinsert",
      }),
    },
    -- }}}
    -- {{{ formatting
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = require("lspkind").cmp_format({
        mode = "symbol",
        maxwidth = 50,
        symbol_map = {
          Text = " ",
        },
      }),
    },
    -- }}}
    -- {{{ snippet
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    -- }}}
    -- {{{ mappings
    mapping = {
      ["<C-d>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_next_item()
        else
          cmp.complete()
        end
      end, { "i", "s" }),
      ["<C-s>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
      -- `select` makes it so this also works if no completions have been selected
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
    },
    -- }}}
    -- {{{ sources
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffers" },
      { name = "emoji" },
      { name = "path" },
      { name = "digraphs" },
    }),
    -- }}}
  }

  local searchOpts = {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  }

  local cmdlineOpts = {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
      { name = "cmdline" },
    }),
  }

  cmp.setup(opts)
  cmp.setup.cmdline("/", searchOpts)
  cmp.setup.cmdline(":", cmdlineOpts)
end

return M
