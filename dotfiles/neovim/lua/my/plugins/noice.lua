local H = require("my.helpers")
local M = {}

local function skip_containing(string, opts)
  local defaultOptions = { event = "msg_show", kind = "", find = string }
  local filter = H.mergeTables(defaultOptions, opts or {})
  return { filter = filter, opts = { skip = true } }
end

function M.setup()
  -- s - search hit bottom messages
  -- c - no pattern found and whatnot
  vim.opt.shortmess:append("scC")
  -- vim.opt.shortmess = "sc"

  require("noice").setup({
    cmdline = {
      view = "cmdline",
      format = {
        search_down = { kind = "search", pattern = "^/", icon = "🔎", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = "🔎", lang = "regex" }
      }
    },
    routes = {
      -- Filter out "Written ..." messages
      skip_containing("written"),
      skip_containing("search hit", { event = "wmsg" }),
      skip_containing("pattern not found", { event = "msg_show" })
    },
    lsp = { progres = { enabled = false } }
  })
end

return M
