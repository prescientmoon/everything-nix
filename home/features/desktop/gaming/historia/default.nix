{
  pkgs ? import <nixpkgs> { },
}:
pkgs.python3Packages.callPackage ./historia.nix { }
