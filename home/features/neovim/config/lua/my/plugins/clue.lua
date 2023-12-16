local M = {
  "echasnovski/mini.clue",
  lazy = false,
}

function M.config()
  local miniclue = require("mini.clue")
  miniclue.setup({
    triggers = {
      -- Leader triggers
      { mode = "n", keys = "<leader>" },
      { mode = "x", keys = "<leader>" },
      { mode = "v", keys = "<leader>" },
    },
    clues = {
      -- Enhance this by adding descriptions for <Leader> mapping groups
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.windows(),
      miniclue.gen_clues.z(),
      {
        mode = "n",
        keys = "<leader>f",
        desc = "[F]iles",
      },
      {
        mode = "n",
        keys = "<leader>g",
        desc = "[G]o to",
      },
      {
        mode = "n",
        keys = "<leader>r",
        desc = "[R]ename / [R]eplace / [R]eload",
      },
      {
        mode = "n",
        keys = "<leader>l",
        desc = "[L]ocal",
      },
      {
        mode = "n",
        keys = "<leader>w",
        desc = "[W]orkspace",
      },
      {
        mode = "n",
        keys = "<leader>y",
        desc = "[Y]ank",
      },
      {
        mode = "n",
        keys = "<leader>s",
        desc = "[S]ettings",
      },
      {
        mode = "n",
        keys = "<leader>v",
        desc = "[V]imux",
      },
      {
        mode = "n",
        keys = "<leader>h",
        desc = "git [h]hunks",
      },
      {
        mode = "n",
        keys = "<leader>VH",
        postkeys = "<leader>V",
      },
      {
        mode = "n",
        keys = "<leader>VJ",
        postkeys = "<leader>V",
      },
      {
        mode = "n",
        keys = "<leader>VK",
        postkeys = "<leader>V",
      },
      {
        mode = "n",
        keys = "<leader>VL",
        postkeys = "<leader>V",
      },
      {
        mode = "n",
        keys = "<leader>Vf",
        postkeys = "<leader>V",
      },
    },
  })

  require("my.keymaps").nmap("Q", ":wqa<cr>", "Save all files and [q]uit")
end

return {}
