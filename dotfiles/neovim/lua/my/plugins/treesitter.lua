local env = require("my.helpers.env")

local M = {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        --{{{Languages
        ensure_installed = {
          "bash",
          "javascript",
          "typescript",
          "c",
          "cpp",
          "css",
          "dockerfile",
          "elixir",
          "fish",
          "html",
          "json",
          "jsonc",
          "latex",
          "python",
          "rust",
          "scss",
          "toml",
          "tsx",
          "vim",
          "yaml",
          "nix",
          "lua",
        },
        sync_install = false,
        --}}}
        --{{{ Highlighting
        highlight = {
          enable = true,
          disable = { "kotlin" },
          additional_vim_regex_highlighting = false,
        },
        --}}}
        textobjects = {
          --{{{ Select
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          --}}}
          --{{{ Move
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
            },
          },
          --}}}
        },
        indent = { enable = true },
      })
    end,
  },
  {
    -- show context on closing parenthesis
    "haringsrob/nvim_context_vt",
    event = "BufReadPost",
    cond = env.vscode.not_active(),
  },
  {
    -- show context at top of file
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    cond = env.vscode.not_active(),
    opts = { enable = true },
  },
}

return M
