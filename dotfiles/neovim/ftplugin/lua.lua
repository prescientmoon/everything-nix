local opts = function(desc)
  return { desc = desc, buffer = true }
end

local function runLocal(functionName)
  return function()
    local path = vim.api.nvim_buf_get_name(0)
    local status, M = pcall(dofile, path)

    if status then
      if M ~= nil then
        if type(M[functionName]) == "function" then
          M[functionName]()
          print("M." .. functionName .. "() executed succesfully!")
        else
          print("Module does not return a " .. functionName .. " function")
        end
      else
        print("Module returned nil")
      end
    else
      print("Cannot import current file :(")
    end
  end
end

vim.keymap.set("n", "<leader>lf", ":source %<cr>", opts("Run [l]ua [f]ile "))
vim.keymap.set(
  "n",
  "<leader>ls",
  runLocal("setup"),
  opts("Run .[s]etup() in current file")
)
vim.keymap.set(
  "n",
  "<leader>lc",
  runLocal("config"),
  opts("Run .[c]onfig() in current file")
)
