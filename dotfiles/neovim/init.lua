local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

-- Basic options
opt.joinspaces = false              -- No double spaces with join
opt.list = true                     -- Show some invisible characters

opt.number = true                   -- Show line numbers
opt.relativenumber = true           -- Relative line numbers

opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = 2                  -- Size of an indent
opt.termguicolors = true            -- True color support

opt.ignorecase = true               -- Ignore case
opt.smartcase = true                -- Do not ignore case with capitals

opt.smartindent = true              -- Insert indents automatically

opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current

opt.wrap = false                    -- Disable line wrap
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode

-- Set theme
require('github-theme').setup({
    theme_style = "light"
})

-- Import my other files
require('my.keymaps').setup()
require('my.plugins').setup()
