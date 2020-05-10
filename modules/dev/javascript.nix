{ pkgs, ... }:
let
  fromNpm = import ./npm { inherit pkgs; };
  node = pkgs.nodejs_latest;
in {
  home-manager.users.adrielus.home.packages = with pkgs;
    with nodePackages;
    with fromNpm; [
      node
      node2nix

      pnpm
      (yarn.override { nodejs = node; })

      tsdx
    ];
}
