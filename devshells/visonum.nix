# Shell containing the tools I most commonly use for work
{ pkgs, inputs }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ purescript spago typescript nodejs ];
}
