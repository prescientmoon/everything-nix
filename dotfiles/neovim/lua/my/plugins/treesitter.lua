local M = {
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
      },
      sync_install = false,
      --}}}
      --{{{ Highlighting
      highlight = {
        enable = true,
        disable = { "kotlin", "tex", "latex" },
        additional_vim_regex_highlighting = false,
      },
      --}}}
      --{{{ Incremental selection
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = "<C-s>",
          node_decremental = "<C-b>",
        },
      },
      --}}}
      --{{{ Textsubjects
      textsubjects = {
        enable = true,
        keymaps = {
          ["."] = "textsubjects-smart",
          [";"] = "textsubjects-container-outer",
        },
      },
      --}}}
      textobjects = {
        --{{{ Select
        select = {
          enable = false,
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
}

return M
