# shell containing the tools i most commonly use for haskell work!
{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    ghc
    hpack
    stack
    cabal-install
    haskellPackages.implicit-hie # Automatically generate hie.yaml!
  ];
}

