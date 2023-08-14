# shell containing the tools i most commonly use for haskell work!
{ pkgs, ... }:
pkgs.mkShell {
  nativebuildinputs = with pkgs; [ ghc hpack stack cabal-install ];
}

