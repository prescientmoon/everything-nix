# Shell containing the tools I most commonly use for work
{ pkgs, inputs, ... }:
let
  pythonDeps = ps: with ps; [ python-slugify rtoml ];
  zolaObsidianPython = pkgs.python3.withPackages pythonDeps;
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ zolaObsidianPython pkgs.zola cargo rustup ];
}
