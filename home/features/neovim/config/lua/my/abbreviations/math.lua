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
  -- {{{ Special chars
  -- System for writing special characters which need to also be easly
  -- accessible as {sub/super}scripts.
  --
  -- The reason epsilon and lambda are separated out from everything else in
  -- the pattern is because they are the only ones where `foo` doesn't expand
  -- to `\\foo` directly (so I saved some keystrokes by letting scrap.nvim
  -- repeat everything for me).
  {
    "{,e,s}{{eps,lam},{star,delta,Delta,pi,tau,psi,phi,rho,sigma,alpha,beta,theta,gamma,omega,Omega}}",
    "{,^,_}\\\\{{epsilon,lambda},{}}",
    options = A.no_capitalization,
  },
  -- }}}
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

M.notation = {
  -- {{{ Exponents and subscripts:
  --   {operation}{argument}
  --   - operation = e (exponent) | s (subscript)
  --   - argument = t{special} | {basic}
  --   - basic = 0-9|n|i|t|k
  --   - special =
  --     - "p" => +
  --     - "m" => -
  --     - "i" => -1
  {
    "{e,s}{{0,1,2,3,4,5,6,7,8,9,n,i,t,k,m},t{i,m,p}}",
    "{^,_}{{},{\\{-1\\},-,+}}",
  },
  -- }}}
}

function M.setup()
  A.manyGlobalAbbr(scrap.expand_many(M.words))
  A.manyGlobalAbbr(scrap.expand_many(M.notation, { capitalized = false }))
end

return M
