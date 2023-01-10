local M = {
  -- removes the need for spamming w or e
  "ggandor/leap.nvim",
  name = "leap",
  event = "VeryLazy"
}

function M.config()
  require("leap").add_default_mappings()
end

-- (something)
-- something

return M
