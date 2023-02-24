local env = require("my.helpers.env")
local K = require("my.keymaps")

local M = {
  "glacambre/firenvim", -- vim inside chrome
  lazy = false,
  cond = env.firenvim.active(),
}

function M.config()
  vim.g.firenvim_config = {
    localSettings = {
      [".*"] = {
        filename = "/tmp/firenvim_{hostname}_{pathname}_{selector}_{timestamp}.{extension}",
      },
    },
  }

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

  -- Disable status line
  vim.opt.laststatus = 0
end

return M
