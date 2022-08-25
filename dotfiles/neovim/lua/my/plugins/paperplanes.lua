local M = {}

function M.setup()
  require("paperplanes").setup({
    provider = "paste.rs"
  })
end

return M
