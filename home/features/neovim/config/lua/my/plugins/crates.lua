local K = require("my.keymaps")
local M = {
  "saecki/crates.nvim",
  event = "BufReadPost Cargo.toml",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local crates = require("crates")

    crates.setup({
      null_ls = {
        enabled = true,
        name = "crates.nvim",
      },
    })

    vim.api.nvim_create_autocmd("InsertEnter", {
      group = vim.api.nvim_create_augroup("CmpSourceCargo", {}),
      pattern = "Cargo.toml",
      callback = function()
        require("cmp").setup.buffer({ sources = { { name = "crates" } } })
      end,
    })

    local function nmap(from, to, desc)
      K.nmap(from, to, desc, true, true)
    end

    nmap("<leader>lct", crates.toggle, "[c]rates [t]oggle")
    nmap("<leader>lcr", crates.reload, "[c]rates [r]efresh")

    nmap("<leader>lcH", crates.open_homepage, "[c]rates [H]omepage")
    nmap("<leader>lcR", crates.open_repository, "[c]rates [R]repository")
    nmap("<leader>lcD", crates.open_documentation, "[c]rates [D]ocumentation")
    nmap("<leader>lcC", crates.open_crates_io, "[c]rates [C]rates.io")

    nmap("<leader>lcv", crates.show_versions_popup, "[c]rates [v]ersions")
    nmap("<leader>lcf", crates.show_features_popup, "[c]rates [f]eatures")
    nmap("<leader>lcd", crates.show_dependencies_popup, "[c]rates [d]eps")
    nmap("K", crates.show_popup, "crates popup")

    local wk = require("which-key")

    wk.register({
      ["<leader>lc"] = {
        name = "[l]ocal [c]rates",
      },
    })
  end,
}

return M
