require("my.abbreviations.unicode").setup()

local tempest = require("my.tempest")
tempest.wrapping.enable()

vim.treesitter.start()
