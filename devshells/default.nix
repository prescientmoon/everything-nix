args: {
  haskell = import ./haskell.nix args;
  purescript = import ./purescript.nix args;
  rwtw = import ./rwtw.nix args;
  typst = import ./typst.nix args;
  lua = import ./lua.nix args;
  bootstrap = import ./bootstrap/shell.nix args;
}

