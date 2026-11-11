{ pkgs, ... }:
{
  imports = [
    ./global.nix
    ./features/neovim
  ];

  home.stateVersion = "26.05";
  home.packages = with pkgs; [ ];

  satellite = {
    dev.enable = true; # Enable symlinks outside the nix store
  };
}
