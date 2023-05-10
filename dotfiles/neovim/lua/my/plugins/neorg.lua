local M = {
  "nvim-neorg/neorg",
  build = ":Neorg sync-parsers",
  dependencies = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" },
  ft = "norg",
  config = function()
    require("neorg").setup({
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.integrations.telescope"] = {},
        -- {{{ Completions
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
          },
        },
        -- }}}
        -- {{{ Dirman
        ["core.dirman"] = { -- Manages Neorg workspaces
          config = {
            workspaces = {
              notes = "~/Neorg",
              ["uni-notes"] = "~/Projects/uni-notes",
            },
          },
        },
        -- }}}
        -- {{{ Keybinds
        ["core.keybinds"] = {
          config = {
            hook = function(keybinds)
              -- Binds the `gtd` key in `norg` mode to execute `:echo 'Hello'`
              keybinds.map("norg", "n", "gtd", "<cmd>echo 'Hello!'<CR>")
            end,
          },
        },
        -- }}}
      },
    })

    -- {{{ Lazy cmp loading
    vim.api.nvim_create_autocmd("InsertEnter", {
      group = vim.api.nvim_create_augroup("CmpSourceNeorg", {}),
      pattern = "*.norg",
      callback = function()
        require("cmp").setup.buffer({ sources = { { name = "neorg" } } })
      end,
    })
    -- }}}
  end,
}

return M
