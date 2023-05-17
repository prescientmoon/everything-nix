# Shell for using a pinned version of typst
{ pkgs, upkgs, inputs, ... }:
pkgs.mkShell {
  nativeBuildInputs = [
    # REASON: not on nixpkgs-stable
    upkgs.typst
  ];
}
