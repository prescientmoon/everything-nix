return {
  "folke/neoconf.nvim",
  cmd = "Neoconf",
  config = {
    -- import existing settings from other plugins
    import = {
      vscode = true, -- local .vscode/settings.json
      coc = false, -- global/local coc-settings.json
      nlsp = false, -- global/local nlsp-settings.nvim json settings
    },
  },
}
