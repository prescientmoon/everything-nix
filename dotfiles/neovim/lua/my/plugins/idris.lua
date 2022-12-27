local lspconfig = require("my.plugins.lspconfig")

local M = {}

function M.setup()
  local idris2 = require("idris2")

  idris2.setup({
    server = {
      on_attach = function(client, bufnr)
        lspconfig.on_attach(client, bufnr)

        local function nmap(from, to, desc)
          vim.keymap.set("n", "<leader>I" .. from, function()
            require("idris2.code_action")[to]()
          end, { desc = desc, bufnr = true })
        end

        nmap("C", "make_case", "Make [c]plit")
        nmap("L", "make_lemma", "Make [l]emma")
        nmap("c", "add_clause", "Add [c]lause")
        nmap("s", "expr_search", "Expression [s]earch")
        nmap("d", "generate_def", "Generate [d]efinition")
        nmap("s", "case_split", "Case [s]plit")
        nmap("h", "refine_hole", "Refine [h]ole")

        local status, wk = pcall(require, "which-key")

        if status then
          wk.register({ ["<leader>I"] = { name = "[I]dris", buffer = bufnr } })
        end
      end,
    },
    client = { hover = { use_split = true } },
  })
end

return M
