local A = require("my.abbreviations")
local scrap = require("scrap")
local M = {}

M.symols = {
  { "mto", ">>=" }, -- [M]onadic [t]o
  { "oalt", "<|>" }, -- [O]peration [A]lternative
  { "omono", "<>" }, -- [O]peration [M]onoid
}

M.types = {
  { "tarr", "Array" },
  { "tlis", "List" },
  { "tmay", "Maybe" },
  { "teff", "Effect" },
  { "tio", "IO" },
  { "taff", "Aff" },
  { "tnea", "NonEmptyArray" },
}

M.functions = {
  { "tfold", "toUnfoldable" }, -- [T]o [f]oldable
  { "ffold", "fromFoldable" }, -- [F]rom un[f]oldable
}

function M.setup()
  A.manyLocalAbbr(scrap.expand_many(M.types, A.no_capitalization))
  A.manyLocalAbbr(scrap.expand_many(M.symols, A.no_capitalization))
  A.manyLocalAbbr(scrap.expand_many(M.functions, A.no_capitalization))
end

return M
