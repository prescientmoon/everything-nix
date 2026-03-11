-- Enable experimental Lua loader
vim.loader.enable()
vim.opt.runtimepath:prepend(vim.g.nix_extra_runtime)

local tempest = require("my.tempest")
local nix = require("nix")

-- {{{ Simple Vim options
-- <leader> will get replaced by <space> inside keybinds
vim.g.mapleader = " "

-- Basic options
vim.opt.joinspaces = false -- No double spaces with join (mapped to qj in my config)
vim.opt.list = false -- I don't want to show things like tabs
vim.opt.signcolumn = "yes" -- Keeps the sign column of a consistent width

-- tcqj are there by default
-- - "t" automatically wraps text
-- - "c" automatically wraps comments
-- - "q" allows re-flowing comments with gq
-- - "j" removes comment leaders when joining lines
-- - "r" automatically continues comments on enter
vim.opt.formatoptions = "tcqjr"
vim.opt.breakindent = true -- Indentation-aware word wrapping.

vim.opt.scrolloff = 4 -- Starts scrolling 4 lines from the edge of the screen
vim.opt.termguicolors = true -- True color support

vim.opt.wildmode = { "list", "longest" }

-- Command-line completion mode
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Default to rounded borders for floating windows
vim.opt.winborder = "rounded"

-- Persist the undo history across restarts
vim.opt.undofile = true

-- Line numbers
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers

-- Indents
vim.opt.expandtab = true -- Use spaces for the tab char
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.tabstop = 2 -- Size of tab character
vim.opt.shiftround = true -- When using < or >, rounds to closest multiple of shiftwidth
vim.opt.smartindent = true -- Insert indents automatically

-- Casing
vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true -- Do not ignore case with capitals

-- Splits
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.inccommand = "split" -- Show off-screen ":%s" changes in their own window

-- Folding
vim.opt.foldmethod = "marker" -- use {{{ }}} for folding
vim.opt.foldcolumn = "0" -- show no column with folds on the left
-- }}}

-- {{{ Disable window background blending / pseudo-transparency
tempest.createAutocmd({
  event = "FileType",
  group = "WinblendSettings",
  action = function()
    vim.opt.winblend = 0
  end,
})
-- }}}
-- {{{ Allow quitting certain buffers by hitting "qq"
tempest.create_autocmd({
  event = "FileType",
  group = "BasicBufferQuitting",
  pattern = { "help", "qf" },
  action = function(ctx)
    tempest.createKeymap({
      mapping = "qq",
      action = "<cmd>close<cr>",
      desc = "[q]uit current buffer",
    }, ctx)
  end,
})
-- }}}
-- {{{ Automatically manage cmdheight
do
  local group = vim.api.nvim_create_augroup("ManageCmdHeight", {})
  vim.opt.cmdheight = 0 -- Hide command line when it's not getting used

  tempest.createAutocmd({
    event = "CmdlineEnter",
    group = group,
    action = function()
      vim.opt.cmdheight = 1
    end,
  })

  tempest.createAutocmd({
    event = "CmdlineLeave",
    group = group,
    action = function()
      vim.opt.cmdheight = 0
    end,
  })
end
-- }}}

-- Keybinds
-- {{{ Free up q and Q
-- Move q -> <c-q>
tempest.moveKeymap({
  mapping = "<c-q>",
  action = "q",
  desc = "Record macro",
})

-- Move Q -> <c-Q>
tempest.moveKeymap({
  mapping = "<c-s-q>",
  action = "Q",
  desc = "Repeat last recorded macro",
})
-- }}}
-- {{{ Save & quit with Q
tempest.createKeymap({
  mapping = "Q",
  action = ":wqa<cr>",
  desc = "Save all files and [q]uit",
})
-- }}}
-- {{{ Merge lines with qj
tempest.createKeymap({
  mapping = "qj",
  action = "J",
  desc = "join lines",
})
-- }}}
-- {{{ Insert mode comment tricks
tempest.createKeymap({
  mode = "i",
  mapping = "<c-cr>",
  action = function()
    vim.paste({ "", "" }, -1)
  end,
  desc = "Insert newline without continuing the current comment",
})

tempest.createKeymap({
  mode = "i",
  mapping = "<c-s-cr>",
  -- This is a bit scuffed and might not work for all languages...
  -- In fact, it only works for indented comment strings of at most two
  -- characters, or unindented comment strings of precisely two characters :/
  action = "<cmd>norm O<bs><bs><bs><cr>",
  desc = "Insert newline above without continuing the current comment",
})
-- }}}
-- {{{ Fold creation
tempest.createKeymap({
  mode = "v",
  mapping = "<c-i>",
  action = function()
    local name = vim.fn.input("Fold name: ")
    local commentstring = vim.o.commentstring
    local markers = { "{{{", "}}}" }
    local start_comment =
      string.gsub(commentstring, "%%s", markers[1] .. " " .. name)
    local end_comment = string.gsub(commentstring, "%%s", markers[2])

    -- Leave visual mode
    local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    vim.api.nvim_feedkeys(esc, "x", false)

    vim.cmd(":'>put='" .. end_comment .. "'")
    vim.cmd(":'<-1put='" .. start_comment .. "'")
  end,
  desc = "create fold",
})
-- }}}
-- {{{ Replace word in file
tempest.createKeymap({
  mapping = "<leader>rw",
  action = ":%s/<C-r><C-w>/",
  desc = "[R]eplace [w]ord in file",
})
-- }}}
-- {{{ Paste.rs integration
-- TODO: integrate with share.moonythm.dev instead
tempest.createKeymap({
  mapping = "<leader>yp",
  action = "<cmd>!curl --data-binary @% https://paste.rs | wl-copy<cr>",
  desc = "[y]ank [p]aste.rs link to clipboard",
})

tempest.createKeymap({
  mode = "v",
  mapping = "<leader>yp",
  action = "<cmd>w !curl --data-binary @- https://paste.rs | wl-copy<cr>",
  desc = "[y]ank [p]aste.rs link to clipboard",
})
-- }}}

-- Option toggles
-- {{{ Color column handling
tempest.createKeymap({
  mapping = "<leader>sc",
  action = tempest.colorcolumn.toggle,
  desc = "toggle the color[c]olumn",
})
-- }}}
-- {{{ Word wrap handling
vim.opt.wrap = false
tempest.createKeymap({
  mapping = "<leader>sw",
  action = tempest.wrapping.toggle,
  desc = "toggle word [w]rap",
})
-- }}}
-- {{{ Spell-checker handling
vim.opt.spell = true
tempest.createKeymap({
  mapping = "<leader>ss",
  action = function()
    vim.opt.spell = not vim.o.spell
  end,
  desc = "toggle [s]pell checking",
})
-- }}}

tempest.configureMany(nix.pre)
require("my.lazy").setup()
tempest.configureMany(nix.post)

-- {{{ Language servers & diagnostics
-- Display error messages inline
vim.diagnostic.config({ virtual_text = true })

-- Enable language servers
-- Additional configuration can be found in `after/lsp/*.lua`
vim.lsp.enable({
  "purescriptls",
  "lua_ls",
  "texlab",
  "nixd",
  "tinymist",
  "cssls",
  "jsonls",
  "dhall_lsp_server",
  "elmls",
  "csharp_ls",
  "ols",
  "hyprls",
  "glsl_analyzer",
  "ruff",
  "svelte",
  "emmet_language_server",
  "just",
})

tempest.createKeymap({
  mapping = "J",
  action = vim.diagnostic.open_float,
  desc = "Open current diagnostic",
})

tempest.createKeymap({
  mapping = "<leader>dl",
  action = function()
    vim.diagnostic.setloclist()
    vim.cmd("lopen")
  end,
  desc = "[D]iagnostic loclist",
})

tempest.createKeymap({
  mapping = "<leader>dq",
  action = function()
    vim.diagnostic.setqflist()
    vim.cmd("copen")
  end,
  desc = "[D]iagnostic qflist",
})
-- }}}
-- {{{ Neovide-specific configuration
if tempest.envs.neovide then
  vim.g.neovide_opacity = tempest.theme.transparency.applications.value
  vim.g.neovide_cursor_animation_length = 4.0e-2
  vim.g.neovide_cursor_animate_in_insert_mode = false
end
-- }}}
