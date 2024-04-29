local H = require("my.tempest")
local M = {}

-- {{{ Custom overrides
local function theme(callback)
  return function()
    if H.theme.polarity ~= nil then
      vim.o.background = H.theme.polarity
    end

    callback()

    if H.theme.transparency.terminal.enabled then
      vim.cmd([[highlight FloatBorder blend=0 guibg=NONE]])
      -- vim.cmd([[highlight MiniStatuslineInactive blend=0 guibg=NONE]])
      vim.cmd([[highlight MiniStatuslineFilename blend=0 guibg=NONE]])
      -- vim.cmd([[highlight MiniStatuslineFileinfo blend=0 guibg=NONE]])
      -- vim.cmd([[highlight MiniStatuslineDevInfo blend=0 guibg=NONE]])
      vim.cmd([[highlight Statusline blend=0 guibg=NONE]])
      vim.cmd([[highlight StatuslineNC blend=0 guibg=NONE]])
    end
  end
end
-- }}}
-- {{{ Catppuccin
table.insert(M, {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  enabled = H.theme_contains("Catppuccin"),
  config = theme(function()
    local catppuccin = require("catppuccin")
    vim.g.catppuccin_flavour = H.theme_variant("Catppuccin")

    catppuccin.setup({
      transparent_background = H.theme.transparency.terminal.enabled,
      integrations = {
        nvimtree = true,
        telescope = true,
        mini = { enabled = true },
      },
    })

    vim.cmd([[highlight NotifyINFOIcon guifg=#d6b20f]])
    vim.cmd([[highlight NotifyINFOTitle guifg=#d6b20f]])

    vim.cmd("colorscheme catppuccin")
  end),
})
-- }}}
-- {{{ Rose-pine
table.insert(M, {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false,
  enabled = H.theme_contains("Rosé Pine"),
  config = theme(function()
    local variant = H.theme_variant("Rosé Pine")

    if variant == "" then
      variant = "main"
    end

    require("rose-pine").setup({
      dark_variant = variant,
    })

    vim.cmd("colorscheme rose-pine")
  end),
})
-- }}}
-- {{{ Gruvbox
table.insert(M, {
  "ellisonleao/gruvbox.nvim",
  name = "gruvbox",
  lazy = false,
  enabled = H.theme_contains("Gruvbox"),
  config = theme(function()
    local variant = H.theme_variant("Gruvbox")
    local contrast = H.helpers.drop_prefix(variant, H.theme.polarity .. ", ")

    require("gruvbox").setup({
      contrast = contrast,
      transparent_mode = H.theme.transparency.terminal.enabled,
    })

    vim.cmd("colorscheme gruvbox")
    vim.cmd(
      "hi MiniStatuslineDevInfo guibg=#"
        .. H.theme.base06
        .. " guifg=#"
        .. H.theme.base00
    )
    vim.cmd("redraw")
  end),
})
-- }}}

return M
