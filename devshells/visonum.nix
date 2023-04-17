# Shell containing the tools I most commonly use for work
{ pkgs, inputs }:
let unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}; in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ unstable.purescript unstable.spago typescript nodejs ];
}
