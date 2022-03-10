{ pkgs }:
let githubVariant = import ./githubVariant.nix;
in
lib.map (theme: pkgs.callPackage theme { }) [
  githubVariant
  "light"
  githubVariant
  "dark"
]
