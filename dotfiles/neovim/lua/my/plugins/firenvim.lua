local env = require("my.helpers.env")
local K = require("my.keymaps")

local M = {
  "glacambre/firenvim", -- vim inside chrome
  lazy = false,
  cond = env.firenvim.active(),
}

M.localSettings = {}

local function make_url_regex(url)
  return "https?:\\/\\/(?:www\\.)?" .. url .. ".*"
end

local function blacklist(url)
  M.localSettings[make_url_regex(url)] = { takeover = "never", priority = 0 }
end

function M.config()
  -- {{{ Filename
  M.localSettings[".*"] = {
    filename = "/tmp/firenvim_{hostname}_{pathname}_{selector}_{timestamp}.{extension}",
  }
  -- }}}
  -- {{{ Ctrl-z to expand window
  K.nmap("<C-z>", function()
    vim.opt.lines = 25
  end, "Expand the neovim window!")
  -- }}}
  -- {{{ Filetype detection
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "firenvim_localhost_notebooks*.txt" },
    group = vim.api.nvim_create_augroup("JupyterMarkdownFiletype", {}),
    callback = function()
      vim.opt.filetype = "markdown"
    end,
  })
  -- }}}
  -- {{{ Disable status line
  vim.opt.laststatus = 0
  -- }}}
  -- {{{ Blacklist websites
  blacklist("web\\.whatsapp\\.com")
  blacklist("twitter\\.com")
  blacklist("desmos\\.com\\/calculator")
  blacklist("geogebra\\.org\\/calculator")
  -- }}}
  -- {{{ Comitting our config changes
  vim.g.firenvim_config = { localSettings = M.localSettings }
  -- }}}
end

function M.setup()
  M.config()
  print(vim.inspect(M.localSettings))
end

return M
