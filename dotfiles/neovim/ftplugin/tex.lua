local A = require("my.abbreviations")

require("my.helpers.wrapMovement").setup()

vim.opt.conceallevel = 0
vim.opt.wrap = true

vim.g.tex_conceal = "abdmg"
-- vim.g.vimtex_syntax_conceal = 1
vim.g.vimtex_imaps_enabled = 0

local abbreviations = {
  -- Greek chars
  { "eps", "\\epsilon" },
  { "delta", "\\delta" },
  { "Delta", "\\Delta" },
  { "pi", "\\pi" },
  { "psi", "\\psi" },
  { "psi", "\\psi" },
  { "alpha", "\\alpha" },
  { "beta", "\\beta" },
  { "theta", "\\theta" },
  { "gamma", "\\gamma" },
  { "nuls", "\\varnothing" },

  -- Exponents
  { "ei", "^{-1}" },
  { "e0", "^{0}" },
  { "e1", "^{1}" },
  { "e2", "^{2}" },
  { "e3", "^{3}" },
  { "e4", "^{4}" },
  { "en", "^{n}" },
  { "etn", "^{-}" },
  { "ett", "^{t}" },
  { "tmat", "^{T}" }, -- Tranpose of a matrix
  { "etp", "^{+}" },

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
  { "Pn", "P(n)" },
  { "foa", "f(a)" },
  { "goa", "g(a)" },
  { "hoa", "h(a)" },
  { "dfx", "f'(x)" },
  { "dgx", "g'(x)" },
  { "dhx", "h'(x)" },

  -- Basic commands
  { "mangle", "\\measuredangle" },
  { "aangle", "\\angle" },
  { "creq", "\\\\&=" },
  { "aeq", "&=" },
  { "leq", "\\leq" },
  { "geq", "\\geq" },
  { "sdiff", "\\setminus" },
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
  { "ssin", "\\sin" },
  { "ccos", "\\cos" },
  { "lln", "\\ln" },
  { "frl", "\\forall" },
  { "exs", "\\exists" },
  { "iinf", "\\infty" },
  { "ninf", "-\\infty" },
  { "nlnl", "\\pm" }, -- had this as npnp first but it was hard-ish to type
  { "ccup", "\\cup" },
  { "ccap", "\\cap" },
  { "nope", "\\bot" },
  { "yee", "\\top" },
  { "ccan", "\\cancel" },
  { "comp", "\\circ" },
  { "mul", "\\cdot" },
  { "smul", "\\times" },
  { "texpl", "&& \\text{}" },
  { "card", "\\#" },

  -- words
  { "rref", "reduced row echalon form" }
}

A.manyLocalAbbr(abbreviations)
