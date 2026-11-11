{ pkgs, ... }:
{
  imports = [
    ./global.nix
    ./features/neovim
  ];

  home.stateVersion = "23.05";
  home.packages = with pkgs; [ ];

  satellite = {
    dev.enable = true; # Enable symlinks outside the nix store
  };
}
