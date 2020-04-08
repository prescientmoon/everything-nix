{ pkgs, ... }:
let fromNpm = import ./npm { inherit pkgs; };
in {
  home-manager.users.adrielus.home.packages = with pkgs; [
    nodejs
    nodePackages.node2nix
    fromNpm.pnpm
  ];
}
