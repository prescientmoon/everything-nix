# Shell for running the rain world tech wiki locally
{ pkgs, ... }:
let
  # Python packages the zola obsidian project expects.
  pythonDeps = ps: with ps; [ python-slugify rtoml ];

  # Plugins used by the zola obsidian project
  zolaObsidianPython = pkgs.python3.withPackages pythonDeps;
in
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [ zolaObsidianPython zola cargo rustup ];
}
