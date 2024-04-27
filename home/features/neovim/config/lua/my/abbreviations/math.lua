local A = require("my.abbreviations")
local scrap = require("scrap")
local M = {}

local function nocap(d)
  d.options = A.no_capitalization
  return d
end

M.words = {
  -- {{{ General phrases
  { "thrf", "therefore" },
  { "bcla", "by contradiction let's assume" },
  { "wlg", "without loss of generality" },
  { "tits", "that is to say," },
  { "wpbd", "we will prove the statement in both directions." },
  { "stam{,s}", "statement{}" },
  { "{ww,tt}{m,i}", "{which,this} {means,implies}" },
  { "cex{,s}", "counterexample{}" },
  { "er{t,s,r}", "{transitivity,symmetry,reflexivity}" },
  -- }}}
  -- {{{ Calculus & analysis
  { "ib{p,s}", "integration by {parts,substitution}" },
  { "{o,c,}nb{,h}{,s}", "{open,closed,} neighbour{,hood}{}" },
  {
    "{n,}{{c,}d,iv,it}ble",
    "{non-,}{{continuously,} differentia,inverti,integra}ble",
  },
  nocap({ "lshiz{c,}", "Lipschitz{ condition,}" }),
  -- }}}
  -- {{{ Linear algebra
  { "rref", "reduced row echalon form" },
  { "eg{va,ve,p}{,s}", "eigen{value,vector,pair}{}" },
  { "mx{,s}", "matri{x,ces}" },
  { "dete{,s}", "determinant{}" },
  { "ort{n,g}", "orto{normal,gonal}" },
  { "l{in,de}", "linearly {independent,dependent}" },
  { "lcon{,s}", "linear combination{}" },
  { "vst{,s}", "vector space{}" }, -- text vector space
  nocap({ "rizz", "Riesz vector" }), -- 💀
  -- }}}
  -- {{{ Differential equations
  -- Note: we must add the space inside the {} in order for capitalization to work!
  {
    "{{s,o,l},}deq{s,}",
    "{{scalar,ordinary,linear} ,}differential equation{}",
  },
  -- }}}
  -- {{{ Graph theory
  { "vx{,s}", "vert{ex,ices}" },
  { "edg{,s}", "edge{}" },
  -- }}}
}

function M.setup()
  A.manyGlobalAbbr(scrap.expand_many(M.words))
end

return M
