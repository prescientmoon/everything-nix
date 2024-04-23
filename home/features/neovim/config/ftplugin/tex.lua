local A = require("my.abbreviations")
local scrap = require("scrap")

require("my.abbreviations.math").setup()

vim.opt.conceallevel = 0

local abbreviations = {
  -- Other fancy symvols
  { "tmat", "^T" }, -- Transpose of a matrix
  { "cmat", "^*" }, -- Conjugate of a matrix
  { "sneg", "^C" }, -- Set complement
  { "ortco", "^\\bot" }, -- Orthogonal complement
  { "sinter", "^\\circ" }, -- Interior of a set
  { "nuls", "\\varnothing" },

  -- Basic commands
  { "mangle", "\\measuredangle" },
  { "aangle", "\\angle" },
  { "sdiff", "\\setminus" },
  { "sst", "\\subset" },
  { "spt", "\\supset" },
  { "sseq", "\\subseteq" },
  { "speq", "\\supseteq" },
  { "ccan", "\\cancel" },
  { "com", "\\circ" },
  { "mul", "\\cdot" },
  { "smul", "\\times" },
  { "card", "\\#" },
  { "div", "\\|" },
  { "ndiv", "\\not\\|\\:" },
  { "perp", "\\perp" },
  { "cdots", "\\cdots" }, -- center dots
  { "ldots", "\\ldots" }, -- low dots
  { "cldots", ",\\ldots," }, -- comma, low dots
  { "frac", "\\frac" }, -- fraction
  { "lim", "\\lim" }, -- Limit
  { "sup", "\\sup" }, -- supremum
  { "limsup", "\\lim\\sup" }, -- Limit of the supremum
  { "cal", "\\mathcal" }, -- Limit of the supremum
}

local abolishAbbreviations = {
  -- {{{ Set symbols
  --   - nats => naturals
  --   - ints => integers
  --   - rats => rationals
  --   - irats => irationals
  --   - rrea => reals
  --   - comp => complex
  --   - ppri => primes
  --   - ffie => fields
  {
    "{nats,ints,rats,irats,rrea,comp,ppri,ffie}",
    "\\mathbb\\{{N,Z,Q,I,R,C,P,F}\\}",
    options = A.no_capitalization,
  },
  -- }}}
  -- {{{ General function calls:
  --   {function-name}{modifier?}{argument}{argument-modifier?}
  --
  --   - function-name = f/g/h/P
  --   - modifier:
  --     - d => derivative
  --     - 2 => squared
  --     - 3 => cubed
  --     - i => inverse
  --   - argument = x/y/z/a/t/i/n/k
  --   - argument-modifier:
  --     - n => subscript n
  {
    "{f,g,h,P}{d,2,3,i,}{x,y,z,a,t,i,n,k}{n,}",
    "{}{',^2,^3,^\\{-1\\},}({}{_n,})",
  },
  -- }}}
  -- {{{ Graph theory
  -- Graph theory function syntax:
  --   gt[function]{graph}{modifier}
  --   - function:
  --     - basic functions: e/E/v/G/L
  --     - k => connectivity
  --     - a => size of the biggest stable set
  --     - w => size of the biggest clique
  --     - d => biggest degree
  --     - c{target}{kind} => {target} {kind} chromatic number
  --       - target:
  --         - vertices by default
  --         - e => edges
  --       - kind:
  --         - normal by default
  --         - l => list
  --   - graph:
  --     - G by default
  --     - s/x/y/h => S/X/Y/H
  --   - modifier:
  --     - a => '
  --     - 1/2 => _k
  {
    "gt{{e,E,v,V,L},k,a,w,d,md{,e},c{,e}{,l}}{,s,h,x,y}{,a,1,2}",
    "{{},\\kappa,\\alpha,\\omega,\\Delta,\\delta{,'},\\chi{,'}{,_l}}({G,S,H,X,Y}{,',_1,_2})",
    options = A.no_capitalization,
  },
  -- }}}
}

local expanded = scrap.expand_many(abolishAbbreviations)

-- Last I checked this contained 1229 abbreviations
-- print(#abbreviations + #expanded)

A.manyLocalAbbr(abbreviations)
A.manyLocalAbbr(expanded)

vim.opt_local.list = false -- The lsp usese tabs for formatting
