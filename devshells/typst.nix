# Shell for using a pinned version of typst
{ pkgs, ... }:
pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.typst
  ];
}
