local A = require("my.abbreviations")

require("my.helpers.wrapMovement").setup()

vim.opt.conceallevel = 1
vim.opt.wrap = true

vim.g.tex_conceal = "abdmg"

local abbreviations = {
  -- Greek chars
  { "eps", "\\epsilon" },
  { "delta", "\\delta" },
  { "nuls", "\\varnothing" },

  -- Exponents
  { "en1", "^{-1}" },
  { "e1", "^{0}" },
  { "e1", "^{1}" },
  { "e2", "^{2}" },
  { "e3", "^{3}" },
  { "e4", "^{4}" },
  { "en", "^{n}" },
  { "enn", "^{-}" },
  { "epp", "^{+}" },

  -- Subscripts
  { "s0", "_{0}" },
  { "s1", "_{1}" },
  { "s2", "_{2}" },
  { "s3", "_{3}" },
  { "s4", "_{4}" },
  { "sn", "_{n}" },

  -- Function calls
  { "fx", "f(x)" },
  { "gx", "g(x)" },
  { "hx", "h(x)" },
  { "Px", "P(x)" },

  -- Basic commands
  { "leq", "\\leq" },
  { "sst", "\\subset" },
  { "sseq", "\\subseteq" },
  { "neq", "\\neq" },
  { "nin", "\\not\\in" },
  { "iin", "\\in" },
  { "tto", "\\to" },
  { "iip", "\\implies" },
  { "iff", "\\iff" },
  { "land", "\\land" },
  { "lor", "\\lor" },
  { "frl", "\\forall" },
  { "exs", "\\exists" },
}

A.manyLocalAbbr(abbreviations)
