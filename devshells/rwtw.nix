# Shell for running the rain world tech wiki locally
{ pkgs, inputs, ... }:
let
  pythonDeps = ps: with ps; [ python-slugify rtoml ];
  zolaObsidianPython = pkgs.python3.withPackages pythonDeps;
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ zolaObsidianPython zola cargo rustup ];
}
