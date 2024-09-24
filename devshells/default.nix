args: {
  haskell = import ./haskell.nix args;
  lua = import ./lua.nix args;
  purescript = import ./purescript.nix args;
  rwtw = import ./rwtw.nix args;
  typst = import ./typst.nix args;
  web = import ./web.nix args;
  bootstrap = import ./bootstrap/shell.nix args;
}
