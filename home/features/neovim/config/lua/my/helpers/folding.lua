local M = {}

local function createFold(name)
  local commentstring = vim.o.commentstring
  local start_comment = string.gsub(commentstring, "%%s", " {{{ " .. name)
  local end_comment = string.gsub(commentstring, "%%s", " }}}")

  -- Leave visual mode
  local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)

  vim.cmd(":'>put='" .. end_comment .. "'")
  vim.cmd(":'<-1put='" .. start_comment .. "'")
end

function M.setup()
  vim.keymap.set("v", "<C-i>", function()
    local name = vim.fn.input("Fold name: ")
    createFold(name)
  end, { desc = "Create fold markers around area" })
end

return M
