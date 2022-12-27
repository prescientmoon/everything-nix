local A = require("my.abbreviations")
local scrap = require("scrap")

require("my.helpers.wrapMovement").setup()

vim.opt.conceallevel = 0
vim.opt.wrap = true

vim.keymap.set("n", "<leader>lg", function()
  if not pcall(function()
    local a = tonumber(vim.fn.input("A: "))
    local b = tonumber(vim.fn.input("B: "))

    local g, x, y = require("my.helpers.math.mod").gcd(a, b)

    vim.fn.input("Result: " .. g .. " " .. x .. " " .. y)
  end) then vim.fn.input("No results exist") end
end, { buffer = true, desc = "Gcd calculator" })

vim.keymap.set("n", "<leader>li", function()
  if not pcall(function()
    local class = tonumber(vim.fn.input("Mod class: "))
    local num = tonumber(vim.fn.input("Number: "))

    vim.fn.input("Result: " .. require("my.helpers.math.mod").modinverse(num, class))
  end) then vim.fn.input("No results exist") end
end, { buffer = true, desc = "Mod inverse calculator" })

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

  -- words
  { "rref", "reduced row echalon form" }
}

---@type ExpansionOptions
local no_capitalization = { capitalized = false }

-- Todo: convert exponents and subscripts
-- to use this more concise notation.
---@type ExpansionInput[]
local abolishAbbreviations = {
  -- General phrases
  { "thrf", "therefore" },
  { "bcla", "by contradiction let's assume" },
  { "wlg", "without loss of generality" },

  -- Calculus
  { "ib{p,s}", "integration by {parts,substitution}" },

  -- Linear algebra
  { "eg{va,ve,p}{,s}", "eigen{value,vector,pair}{}" },
  { "mx{,s}", "matri{x,ces}" },
  { "dete{,s}", "determinant{}" },
  { "ort{n,g}", "orto{normal,gonal}" },
  { "l{in,de}", "linearly {independent,dependent}" },

  -- My own operator syntax:
  --   - Any operator can be prefixed with "a" to
  --     align in aligned mode
  --   - Any operator can be prefixed with cr to
  --     start a new line and align in aligned mode
  {
    "{cr,a,}{eq,neq,leq,geq,lt,gt}",
    "{\\\\\\&,&,}{=,\\neq,\\leq,\\geq,<,>}",
    options = no_capitalization
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
    options = no_capitalization
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
    options = no_capitalization
  },

  -- Function calls:
  --   {function-name}{modifier?}{argument}
  --
  --   - function-name = f/g/h/P
  --   - modifier:
  --     - d => derivative
  --     - 2 => squared
  --     - 3 => cubed
  --     - i => inverse
  --   - argument = x/a/t/i/n/k
  { "{f,g,h,P}{d,2,3,i,}{x,a,t,i,n,k}", "{}{',^2,^3,^\\{-1\\},}({})" }
}

local expanded = scrap.expand_many(abolishAbbreviations)

A.manyLocalAbbr(abbreviations)
A.manyLocalAbbr(expanded)

vim.keymap.set("n", "<leader>lc", "<cmd>VimtexCompile<cr>",
               { desc = "Compile current buffer using vimtex", buffer = true })
