local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

-- Basic options
opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers

-- Set theme
require('github-theme').setup()

-- Import my other files
require('my.keymaps').setup()