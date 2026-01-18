{
  pkgs ? import <nixpkgs> { },
}:
rec {
  sopsy = pkgs.python3Packages.callPackage ./sopsy.nix { };
  migadux = pkgs.python3Packages.callPackage ./migadux.nix {
    inherit sopsy;
  };
}
