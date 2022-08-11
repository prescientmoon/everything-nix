local arpeggio = require("my.plugins.arpeggio")
local lspconfig = require("my.plugins.lspconfig")

local M = {}

local idrisChords = {
  sc = "case_split",
  mc = "make_case",
  ml = "make_lemma",
  es = "expr_search",
  gd = "generate_def",
  rh = "refine_hole",
  ac = "add_clause"
}

function M.setup()
  local idris2 = require("idris2")

  idris2.setup({
    server = {
      on_attach = function(client, bufnr)
        lspconfig.on_attach(client, bufnr)

        for key, value in pairs(idrisChords) do
          arpeggio.chord("n", "i" .. key,
            ":lua require('idris2.code_action')." ..
            value .. "()<CR>", { settings = "b" })
        end
      end
    },
    client = { hover = { use_split = true } }
  })
end

return M
