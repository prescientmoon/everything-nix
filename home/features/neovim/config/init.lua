-- Enable experimental lua loader
vim.loader.enable()
vim.opt.runtimepath:prepend(vim.g.nix_extra_runtime)

local tempest = require("my.tempest")
local nix = require("nix")

-- TODO: move this
vim.diagnostic.config({ virtual_text = true })

tempest.configureMany(nix.pre)
require("my.lazy").setup()
tempest.configureMany(nix.post)
