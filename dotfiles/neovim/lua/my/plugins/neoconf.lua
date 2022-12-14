local M = {}

function M.setup()
  require("neoconf").setup({
    -- import existing settinsg from other plugins
    import = {
      vscode = true, -- local .vscode/settings.json
      coc = false, -- global/local coc-settings.json
      nlsp = false -- global/local nlsp-settings.nvim json settings
    },
  })
end

return M
