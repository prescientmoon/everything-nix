local A = require("my.abbreviations")
local scrap = require("scrap")
local M = {}

-- {{{ Unicode
M.unicode = {
  -- {{{ Logic
  { "frl", "∀" }, -- [f]o[r]al[l]
  { "exs", "∃" }, -- [e][x]ist[s]
  { "land", "∧" }, -- [l]ogical [and]
  { "Land", "⋀" }, -- arbitrary [l]ogical [and]
  { "lor", "∨" }, -- [l]ogical [or]
  { "Lor", "⋁" }, -- [l]ogical [or]
  { "bot", "⊥" }, -- false
  { "top", "⊤" }, -- true
  { "iip", "⟹" }, -- [i]t [i]m[p]lies
  { "iib", "⟸" }, -- [i]t's [i]mplied [b]y
  { "iff", "⟺" }, -- [if] and only i[f]
  { "lneg", "¬" }, -- [l]ogical [neg]ation
  -- }}}
  -- {{{ Set theory
  { "nolla", "∅" },
  { "carprod", "×" }, -- cartesian product
  { "sect", "∩" }, -- set intersection
  { "Sect", "⋂" }, -- arbitrary set intersection
  { "dsect", "⊓" }, -- disjoint set intersection (whatever that means lol)
  { "union", "∪" }, -- set union
  { "Union", "⋃" }, -- arbitrary set union
  { "dnion", "⊔" }, -- disjoint set union
  -- {{{ Inclusions
  { "sst", "⊂" }, -- [s]ub[s]et
  { "nsst", "⊄" }, -- [n]ot [s]ub[s]et
  { "sseq", "⊆" }, -- [s]ub[s]et or [eq]ual
  { "nsseq", "⊈" }, -- [n]ot [s]ub[s]et or [eq]ual
  { "psseq", "⊊" }, -- [p]roper [s]ub[s]et or [eq]ual
  { "spt", "⊃" }, -- [s]u[p]erset
  { "nspt", "⊅" }, -- [s]u[p]erset
  { "speq", "⊇" }, -- [s]u[p]erset or [eq]ual
  { "nspeq", "⊉" }, -- [n]ot [s]u[p]erset or [eq]ual
  { "pspeq", "⊋" }, -- [p]roper [s]u[p]erset or [eq]ual
  -- }}}
  -- }}}
  -- {{{ Double stroked chars
  { "AA", "𝔸" },
  { "BB", "𝔹" },
  { "CC", "ℂ" },
  { "DD", "ⅅ" },
  { "EE", "𝔼" },
  { "FF", "𝔽" },
  { "GG", "𝔾" },
  { "HH", "ℍ" },
  { "II", "𝕀" },
  { "JJ", "𝕁" },
  { "KK", "𝕂" },
  { "LL", "𝕃" },
  { "MM", "𝕄" },
  { "NN", "ℕ" },
  { "OO", "𝕆" },
  { "PP", "ℙ" },
  { "QQ", "ℚ" },
  { "RR", "ℝ" },
  { "SS", "𝕊" },
  { "TT", "𝕋" },
  { "UU", "𝕌" },
  { "VV", "𝕍" },
  { "WW", "𝕎" },
  { "XX", "𝕏" },
  { "YY", "𝕐" },
  { "ZZ", "ℤ" },
  -- }}}
  -- {{{ Common operators
  { "comp", "∘" }, -- composition
  { "mul", "⋅" }, -- multiplication
  { "sqrt", "√" }, -- square root
  { "cbrt", "∛" }, -- cube root
  -- }}}
  -- {{{ Integrals
  { "int", "∫" }, -- integral
  { "iint", "∬" }, -- integral
  { "iiint", "∭" }, -- integral
  { "pint", "∮" }, -- integral
  { "piint", "∯" }, -- integral
  { "piiint", "∰" }, -- integral
  -- }}}
  -- {{{ Common relations
  { "sim", "∼" }, -- similarity
  { "simeq", "≃" },
  { "cong", "≅" }, -- congruence
  { "defas", "≔" }, -- defined as
  { "eq", "=" }, -- [eq]ual
  { "neq", "≠" }, -- [n]ot [eq]ual
  { "leq", "≤" }, -- [l]ess than or [e][q]ual
  { "geq", "≥" }, -- [g]reater than or [e][q]ual

  { "iin", "∈" }, -- [I]ncluded [i][n]
  { "nin", "∉" }, -- [n]ot included [i][n]
  { "iic", "∋" }, -- [I]n[c]ludes
  { "nic", "∌" }, -- does'[n]t [i]n[c]lude
  -- }}}
  -- {{{ Greek characters
  { "alpha", "α" },
  { "beta", "β" },
  { "gamma", "γ" },
  { "Gamma", "Γ" },
  { "delta", "δ" },
  { "Delta", "Δ" },
  { "eps", "ε" },
  { "zeta", "ζ" },
  { "eta", "η" },
  { "theta", "θ" },
  { "Theta", "Θ" },
  { "iota", "ι" },
  { "kappa", "κ" },
  { "lam", "λ" },
  { "Lam", "Λ" },
  { "mu", "μ" },
  { "nu", "ν" },
  { "xi", "ξ" },
  { "pi", "π" },
  { "Pi", "∏" },
  { "rho", "ρ" },
  { "sigma", "σ" },
  { "Sigma", "Σ" },
  { "tau", "τ" },
  { "upsilon", "υ" },
  { "phi", "ϕ" },
  { "ophi", "φ" }, -- open phi?
  { "Phi", "Φ" },
  { "chi", "χ" },
  { "psi", "ψ" },
  { "Psi", "Ψ" },
  { "omega", "ω" },
  { "Omega", "Ω" },
  -- }}}
  -- {{{ Common symbols
  { "iinf", "∞" },
  { "niinf", "-∞" },
  { "star", "⋆" },
  { "nabla", "∇" },
  { "minidiam", "⋄" },
  { "tto", "→" },
  { "ttoo", "⟶" },
  { "mapto", "↦" },
  { "square", "□" },
  { "rquare", "▢" }, -- rounded square
  { "diam", "◇" },
  -- }}}
  -- {{{ Brackets
  { "langle", "⟨" },
  { "rangle", "⟩" },
  -- }}}
}
-- }}}

function M.setup()
  A.manyLocalAbbr(scrap.expand_many(M.unicode, { capitalized = false }))
end

return M
