local M = {
  "echasnovski/mini.surround",
  event = "BufReadPost",
}

function M.config()
  require("mini.surround").setup({
    mappings = {
      add = "<tab>s", -- Add surrounding in Normal and Visul modes
      delete = "<tab>d", -- Delete surrounding
      find = "<tab>f", -- Find surrounding (to the right)
      find_left = "<tab>F", -- Find surrounding (to the left)
      highlight = "<tab>h", -- Highlight surrounding
      replace = "<tab>r", -- Replace surrounding
      update_n_lines = "", -- Update `n_lines`
    },
    custom_surroundings = {
      ["b"] = {
        input = { "%b()", "^.%s*().-()%s*.$" },
        output = { left = "(", right = ")" },
      },
      ["B"] = {
        input = { "%b{}", "^.%s*().-()%s*.$" },
        output = { left = "{", right = "}" },
      },
      ["r"] = {
        input = { "%b[]", "^.%s*().-()%s*.$" },
        output = { left = "[", right = "]" },
      },
      ["q"] = {
        input = { '".-"', "^.().*().$" },
        output = { left = '"', right = '"' },
      },
      ["a"] = {
        input = { "'.-'", "^.().*().$" },
        output = { left = "'", right = "'" },
      },
    },
  })
end

return M
