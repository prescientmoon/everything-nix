local A = require("my.abbreviations")
local scrap = require("scrap")
local M = {}

M.symbols = {
  { "mto", ">>=" }, -- [M]onadic [t]o
  { "oalt", "<|>" }, -- [O]peration [A]lternative
  { "omono", "<>" }, -- [O]peration [M]onoid
}

function M.setup()
  A.manyLocalAbbr(scrap.expand_many(M.symbols, A.no_capitalization))
end

return M
