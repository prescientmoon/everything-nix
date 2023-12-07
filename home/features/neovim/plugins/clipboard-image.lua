local M = {}

function M.img_name()
  vim.fn.inputsave()
  local name = vim.fn.input("Name: ")
  vim.fn.inputrestore()

  if name == nil or name == "" then
    return os.date("%y-%m-%d-%H-%M-%S")
  end

  return name
end

return M
