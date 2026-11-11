{ pkgs, ... }:
{
  imports = [
    ./global.nix
  ];

  home.stateVersion = "24.05";
  home.packages = with pkgs; [ ];

  satellite = {
    dev.enable = true; # Enable symlinks outside the nix store
  };
}
