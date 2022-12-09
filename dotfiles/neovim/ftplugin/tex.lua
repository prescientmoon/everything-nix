local A = require("my.abbreviations")
local AB = require("my.plugins.abolish")

require("my.helpers.wrapMovement").setup()

vim.opt.conceallevel = 0
vim.opt.wrap = true

vim.g.tex_conceal = "abdmg"
vim.g.vimtex_imaps_enabled = 0
-- vim.g.vimtex_syntax_conceal = 1

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
  { "ints", "\\mathbb{Z}" },
  { "nats", "\\mathbb{N}" },
  { "rats", "\\mathbb{Q}" },
  { "irats", "\\mathbb{I}" },
  { "rrea", "\\mathbb{R}" },
  { "ppri", "\\mathbb{P}" },
  { "ffie", "\\mathbb{F}" },
  { "ccom", "\\mathbb{C}" }, -- Exponents
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
  { "cmat", "^{*}" }, -- Conjugate of a matrix
  { "ortco", "^{\\bot}" }, -- Orthogonal complement
  { "etp", "^{+}" }, -- Subscripts
  { "s0", "_{0}" },
  { "s1", "_{1}" },
  { "s2", "_{2}" },
  { "s3", "_{3}" },
  { "s4", "_{4}" },
  { "sn", "_{n}" }, -- Function calls
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
  { "dhx", "h'(x)" }, -- Basic commands
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
  { "texpl", "&& \\text{}" },
  { "card", "\\#" },
  { "div", "\\|" },
  { "ndiv", "\\not\\|\\:" },

  -- words
  { "rref", "reduced row echalon form" }
}

-- Todo: convert exponents and subscripts
-- to use this more concise notation.
local abolishAbbreviations = {
  { "eg{va,ve,p}{,s}", "eigen{value,vector,pair}{}" },
  { "ib{p,s}", "integration by {parts,substitution}" },
  { "mx{,s}", "matri{x,ces}" },
  { "thrf", "therefore" },
  { "dete{,s}", "determinant{}" },
  { "bcla", "by contradiction let's assume" },
  { "ort{n,g}", "orto{normal,gonal}" },
  { "l{in,de}", "linearly {independent,dependent}" },
  { "wlg", "without loss of generality" },

  -- My own operator syntax:
  --   - Any operator can be prefixed with "a" to
  --     align in aligned mode
  --   - Any operator can be prefixed with cr to
  --     start a new line and align in aligned mode
  { "{cr,a,}{eq,neq,leq,geq,lt,gt}", "{\\\\\\&,&,}{=,\\neq,\\leq,\\geq,<,>}" }
}

A.manyLocalAbbr(abbreviations)
AB.abolishMany(abolishAbbreviations)

vim.keymap.set("n", "<leader>lc", "<cmd>VimtexCompile<cr>",
               { desc = "Compile current buffer using vimtex", buffer = true })
