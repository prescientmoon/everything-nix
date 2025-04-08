local A = require("my.abbreviations")
local scrap = require("scrap")
local M = {}

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
  -- {{{ Common operators
  { "comp", "∘" }, -- composition
  { "mul", "⋅" }, -- multiplication
  { "sqrt", "√" }, -- square root
  { "cbrt", "∛" }, -- cube root
  -- }}}
  -- {{{ Integrals
  { "int", "∫" },
  { "iint", "∬" },
  { "iiint", "∭" },
  { "pint", "∮" },
  { "piint", "∯" },
  { "piiint", "∰" },
  -- }}}
  -- {{{ Common relations
  { "sim", "∼" }, -- similarity
  { "simeq", "≃" }, -- isomorphism
  { "cong", "≅" }, -- congruence

  { "iin", "∈" }, -- [I]ncluded [i][n]
  { "nin", "∉" }, -- [n]ot included [i][n]
  { "iic", "∋" }, -- [I]n[c]ludes
  { "nic", "∌" }, -- does'[n]t [i]n[c]lude
  -- }}}
  -- {{{ Common symbols
  { "star", "⋆" },
  { "nabla", "∇" },
  { "minidiam", "⋄" },
  { "tto", "→" },
  { "ttoo", "⟶" },
  { "mapto", "↦" },
  -- }}}
}

function M.setup()
  A.manyLocalAbbr(scrap.expand_many(M.unicode, { capitalized = false }))
end

return M
