local A = require("my.abbreviations")
local scrap = require("scrap")

require("my.helpers.wrapMovement").setup()

vim.opt.conceallevel = 0

-- vim.opt.foldcolumn = "1"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldmethod = "expr"

-- vim.keymap.set("n", "<leader>lg", function()
--   if not pcall(function()
--     local a = tonumber(vim.fn.input("A: "))
--     local b = tonumber(vim.fn.input("B: "))
--
--     local g, x, y = require("my.helpers.math.mod").gcd(a, b)
--
--     vim.fn.input("Result: " .. g .. " " .. x .. " " .. y)
--   end) then vim.fn.input("No results exist") end
-- end, { buffer = true, desc = "Gcd calculator" })
--
-- vim.keymap.set("n", "<leader>li", function()
--   if not pcall(function()
--     local class = tonumber(vim.fn.input("Mod class: "))
--     local num = tonumber(vim.fn.input("Number: "))
--
--     vim.fn.input("Result: " .. require("my.helpers.math.mod").modinverse(num, class))
--   end) then vim.fn.input("No results exist") end
-- end, { buffer = true, desc = "Mod inverse calculator" })

local abbreviations = {
  -- Greek chars
  { "eps", "\\epsilon" },
  { "delta", "\\delta" },
  { "Delta", "\\Delta" },
  { "pi", "\\pi" },
  { "psi", "\\psi" },
  { "alpha", "\\alpha" },
  { "beta", "\\beta" },
  { "theta", "\\theta" },
  { "gamma", "\\gamma" },
  { "lam", "\\lambda" },
  { "nuls", "\\varnothing" }, -- Other fancy symvols

  { "tmat", "^T" }, -- Tranpose of a matrix
  { "cmat", "^*" }, -- Conjugate of a matrix
  { "ortco", "^{\\bot}" }, -- Orthogonal complement
  { "sinter", "^{\\circ}" }, -- Interior of a set

  -- Basic commands
  { "mangle", "\\measuredangle" },
  { "aangle", "\\angle" },

  { "sdiff", "\\setminus" },
  { "sst", "\\subset" },
  { "sseq", "\\subseteq" },
  { "nin", "\\not\\in" },
  { "iin", "\\in" },
  { "tto", "\\to" },
  { "iip", "\\implies" },
  { "iib", "\\impliedby" },
  { "iff", "\\iff" },
  { "land", "\\land" },
  { "lor", "\\lor" },
  { "ssin", "\\sin" },
  { "ccos", "\\cos" },
  { "ttan", "\\ttan" },
  { "ssec", "\\sec" },
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
  { "card", "\\#" },
  { "div", "\\|" },
  { "ndiv", "\\not\\|\\:" },
  { "perp", "\\perp" },
  { "abs", "\\abs" }, -- custom abs command
  { "norm", "\\norm" }, -- custom norm command
  { "iprod", "\\iprod" }, -- custom inner product command

  -- words
  { "rref", "reduced row echalon form" },
}

-- Todo: convert exponents and subscripts
-- to use this more concise notation.
local abolishAbbreviations = {
  -- General phrases
  { "thrf", "therefore" },
  { "bcla", "by contradiction let's assume" },
  { "wlg", "without loss of generality" },
  { "tits", "that is to say," },
  { "wpbd", "we will prove the statement in both directions." },
  { "stam{,s}", "statement{}" },
  { "nb{,h}{,s}", "neighbour{,hood}{}" },
  { "{ww,tt}{m,i}", "{which,this} {means,implies}" },
  { "cex{,s}", "counterexample{}" },
  { "er{t,s,r}", "{transitivity,symmetry,reflexivity}" },

  -- Calculus
  { "ib{p,s}", "integration by {parts,substitution}" },

  -- Linear algebra
  { "eg{va,ve,p}{,s}", "eigen{value,vector,pair}{}" },
  { "mx{,s}", "matri{x,ces}" },
  { "dete{,s}", "determinant{}" },
  { "ort{n,g}", "orto{normal,gonal}" },
  { "l{in,de}", "linearly {independent,dependent}" },
  { "lcon{,s}", "linear combination{}" },
  { "vsm", "\\vecspace" }, -- math vector space
  { "vst{,s}", "vector space{,s}" }, -- text vector space

  -- Graph theory
  { "vx{,s}", "vert{ex,ices}" },
  { "eg{,s}", "edge{}" },

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

  -- My own operator syntax:
  --   - Any operator can be prefixed with "a" to
  --     align in aligned mode
  --   - Any operator can be prefixed with cr to
  --     start a new line and align in aligned mode
  {
    "{cr,a,}{eq,neq,leq,geq,lt,gt}",
    "{\\\\\\&,&,}{=,\\neq,\\leq,\\geq,<,>}",
    options = A.no_capitalization,
  },

  -- Exponents and subscripts:
  --   {operation}{argument}
  --   - operation = e (exponent) | s (subscript)
  --   - argument = t{special} | {basic}
  --   - basic = 0-9|n|i|t|k
  --   - special =
  --     - "p" => +
  --     - "m" => -
  --     - "i" => -1
  {
    "{e,s}{{0,1,2,3,4,5,6,7,8,9,n,i,t,k},t{i,m,p}}",
    "{^,_}{{},{\\{-1\\},-,+}}",
    options = A.no_capitalization,
  },

  -- Set symbols
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

  -- Function calls:
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
}

local expanded = scrap.expand_many(abolishAbbreviations)

A.manyLocalAbbr(abbreviations)
A.manyLocalAbbr(expanded)

vim.keymap.set(
  "n",
  "<leader>lc",
  "<cmd>VimtexCompile<cr>",
  { desc = "Compile current buffer using vimtex", buffer = true }
)
