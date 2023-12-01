local env = require("my.helpers.env")
local K = require("my.keymaps")

local M = {
  "mhartington/formatter.nvim",
  event = "BufReadPre",
  cond = env.vscode.not_active(),
}

function M.config()
  local any = require("formatter.filetypes.any")
  local formatters = {
    markdown = {
      require("formatter.filetypes.markdown").prettier,
    },
    lua = {
      require("formatter.filetypes.lua").stylua,
    },
    ["*"] = {
      any.remove_trailing_whitespace,
    },
  }

  require("formatter").setup({ filetype = formatters })

  local format = function()
    if formatters[vim.bo.filetype] ~= nil then
      vim.cmd([[Format]])
    elseif next(vim.lsp.get_active_clients({ bufnr = 0 })) == nil then
      vim.lsp.buf.format()
    end
  end

  K.nmap("<leader>F", format, "[F]ormat file")

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("Formatting", { clear = false }),
    callback = format,
  })
end

return M
