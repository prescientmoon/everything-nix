{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    nixfmt
    niv
    cached-nix-shell
  ];
}
