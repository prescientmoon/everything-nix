local M = {}

function M.setup()
  -- Disable filetype.vim
  vim.g.do_filetype_lua = true
  vim.g.did_load_filetypes = false

  -- Basic options
  vim.opt.joinspaces = false -- No double spaces with join
  vim.opt.list = true -- Show some invisible characters
  vim.opt.cmdheight = 0 -- Hide command line when it's not getting used

  -- Line numbers
  vim.opt.number = true -- Show line numbers
  vim.opt.relativenumber = true -- Relative line numbers

  -- TODO: only do this for specific filestypes
  vim.opt.expandtab = true -- Use spaces for the tab char

  vim.opt.scrolloff = 4 -- Lines of context
  vim.opt.shiftround = true -- Round indent
  vim.opt.shiftwidth = 2 -- Size of an indent
  vim.opt.termguicolors = true -- True color support

  vim.opt.ignorecase = true -- Ignore case
  vim.opt.smartcase = true -- Do not ignore case with capitals

  vim.opt.smartindent = true -- Insert indents automatically

  vim.opt.splitbelow = true -- Put new windows below current
  vim.opt.splitright = true -- Put new windows right of current

  vim.opt.wrap = false -- Disable line wrap (by default)
  vim.opt.wildmode = { 'list', 'longest' } -- Command-line completion mode
  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  -- Set leader
  vim.g.mapleader = " "

  -- Folding
  vim.opt.foldmethod = "marker"
end

return M
