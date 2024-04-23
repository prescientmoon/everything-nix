local A = require("my.abbreviations")
local scrap = require("scrap")
local M = {}

M.words = {
  { "thrf", "therefore" },
}

function M.setup()
  A.manyGlobalAbbr(scrap.expand_many(M.words))
end

return M
