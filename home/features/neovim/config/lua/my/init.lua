local M = {}

function M.setup()
  vim.opt.runtimepath:append(vim.g.nix_extra_runtime)

  local tempest = require("my.tempest")
  local nix = require("nix")

  -- Import my other files
  tempest.configureMany(nix.pre)
  require("my.keymaps").setup()
  require("my.lazy").setup()
  tempest.configureMany(nix.post)

  require("luasnip.loaders.from_lua").lazy_load({
    fs_event_providers = {
      libuv = true,
    },
  })
end

return M
