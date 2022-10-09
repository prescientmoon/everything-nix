vim.opt.runtimepath:append("/home/adrielus/Projects/nvim-slam")

local slam = require("slam.")
local M = {}

function M.setup()
  slam.set("n", "ty", ":echo \"slammin'\"<CR>")
  slam.set("i", "ty", "<esc>")
end

return M
