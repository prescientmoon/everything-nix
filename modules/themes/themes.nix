{ pkgs, lib, ... }:
let githubVariant = import ./githubVariant.nix;
in
lib.lists.map (theme: pkgs.callPackage theme { }) [
  (githubVariant { variant = "light"; })
  (githubVariant { variant = "dark"; transparency = 0.8; })
]
