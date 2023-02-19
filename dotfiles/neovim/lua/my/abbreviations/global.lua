local A = require("my.abbreviations")
local scrap = require("scrap")
local M = {}

M.symols = {
  -- Unicode:
  { "iin", "∈" }, -- [I]ncluded [i][n]
  { "mfrl", "∀" }, -- [M]ath [f]o[r]al[l]

  -- Ascii stuff:
  { "tto", "->" }, -- [t]o
  { "ffrom", "<-" }, -- [f]rom
  { "iip", "=>" }, -- [i]t [i]m[p]lies
  { "iib", "<=" }, -- [i]t's [i]mplied [b]ly

  { "leq", "<=" }, -- [l]ess than or [e][q]ual
  { "geq", ">=" }, -- [g]reater than or [e][q]ual
  { "eq", "=" }, -- [e][q]ual
  { "deq", "==" }, -- [d]ouble [e][q]ual
  { "land", "/\\" }, -- [l]ogial [a][n][d]
  { "lor", "\\/" }, -- [l]ogial [o][r]
}

M.words = {
  { "thrf", "therefore" },
  { "frl", "forall" },
}

function M.setup()
  A.manyGlobalAbbr(scrap.expand_many(M.words))
  A.manyGlobalAbbr(scrap.expand_many(M.symols, { capitalized = false }))
end

return M
