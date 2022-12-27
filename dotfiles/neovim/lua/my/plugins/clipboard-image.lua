local M = {
  -- paste images from clipbaord
  "ekickx/clipboard-image.nvim",
  cmd = "PasteImg",
}

local function img_name()
  vim.fn.inputsave()
  local name = vim.fn.input("Name: ")
  vim.fn.inputrestore()

  if name == nil or name == "" then
    return os.date("%y-%m-%d-%H-%M-%S")
  end
  return name
end

function M.init()
  vim.keymap.set(
    "n",
    "<leader>p",
    ":PasteImg<cr>",
    { desc = "[P]aste image from clipboard" }
  )
end

function M.config()
  require("clipboard-image").setup({
    default = {
      img_name = img_name,
    },
    tex = {
      img_dir = { "%:p:h", "img" },
      affix = "\\includegraphics[width=\\textwidth]{%s}",
    },
  })
end

return M
