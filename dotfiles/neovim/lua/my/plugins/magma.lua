local M = {
  "dccsillag/magma-nvim",
  cmd = "MagmaInit",
  config = function()
    local prefix = "<leader>M"

    local status, wk = pcall(require, "which-key")

    if status then
      wk.register({
        [prefix] = {
          desc = "[M]agma",
        },
      })
    end

    vim.keymap.set(
      "n",
      prefix .. "e",
      "<cmd>MagmaEvaluateOperator<cr>",
      { expr = true, silent = true, desc = "[E]valuate motion" }
    )

    vim.keymap.set(
      "n",
      prefix .. "ee",
      "<cmd>MagmaEvaluateLine<cr>",
      { silent = true, desc = "[E]valuate line" }
    )

    vim.keymap.set(
      "n",
      prefix .. "r",
      "<cmd>MagmaReevaluateCell<cr>",
      { silent = true, desc = "[R]e-evaluate cell" }
    )

    vim.keymap.set(
      "n",
      prefix .. "d",
      "<cmd>MagmaDelete<cr>",
      { silent = true, desc = "[D]elete cell" }
    )

    vim.keymap.set(
      "n",
      prefix .. "o",
      "<cmd>MagmaShowOutput<cr>",
      { silent = true, desc = "Show [o]utput" }
    )

    vim.keymap.set(
      "v",
      prefix .. "e",
      "<cmd><C-u>MagmaEvaluateVisual<cr>",
      { silent = true, desc = "[E]vluate visual selection" }
    )
  end,
}

return M
