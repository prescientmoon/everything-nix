{ pkgs, upkgs, ... }:
{
  imports = [
    ./global.nix

    ./features/desktop/gaming
    ./features/wayland/global.nix
    ./features/neovim
  ];

  home.stateVersion = "26.05";
  home.username = "moon";

  # Arbitrary extra packages
  home.packages = with pkgs; [
    kdePackages.kdenlive # Video editor
    upkgs.freetube # YouTube client
  ];

  satellite = {
    dev.enable = true; # Enable symlinks outside the nix store
  };
}
