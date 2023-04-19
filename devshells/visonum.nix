# Shell containing the tools I most commonly use for work
{ pkgs, upkgs, inputs }:
pkgs.mkShell {
  # REASON: purescript 0.15.7 and it's associated spago
  nativeBuildInputs = [ upkgs.purescript upkgs.spago pkgs.typescript pkgs.nodejs ];
}
