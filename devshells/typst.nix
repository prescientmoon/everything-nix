# Shell for using a pinned version of typst
{ pkgs, upkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = [
    # REASON: version 0.7.0
    upkgs.typst
  ];
}
