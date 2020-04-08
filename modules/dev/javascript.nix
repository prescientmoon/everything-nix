{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    nodejs
    nodePackages.node2nix
  ];
}
