local lazy_path = os.getenv("LAZY_NVIM_PATH")

if lazy_path == nil then
  error("Lazy.nvim not installed!")
end

vim.opt.runtimepath:prepend(lazy_path)

require("my.init").setup()
