{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [ rustup rust-analyzer ];
}
