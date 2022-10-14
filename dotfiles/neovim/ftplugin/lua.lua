local opts = function(desc)
  return { desc = desc, buffer = true }
end

vim.keymap.set("n", "<leader>lf", ":source %<cr>", opts("Run current lua file"))
vim.keymap.set("n", "<leader>ls", function()
  local path = vim.api.nvim_buf_get_name(0)
  local status, M = pcall(dofile, path)

  if status then
    if M ~= nil then
      if type(M.setup) == "function" then
        M.setup()
        print("M.setup() executed succesfully!")
      else
        print("Module does not return a setup function")
      end
    else
      print("Module returned nil")
    end
  else
    print("Cannot import current file :(")
  end
end, opts("Run .setup() in current file"))

