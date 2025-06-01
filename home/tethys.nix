{ pkgs, ... }:
{
  imports = [
    ./global.nix

    ./features/cli/productivity
    ./features/desktop/gaming
    ./features/desktop/gaming/edopro.nix
    ./features/wayland/hyprland

    ./features/neovim
  ];

  home.stateVersion = "23.05";

  satellite = {
    dev.enable = true; # Enable symlinks outside the nix store

    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
      }
    ];
  };
}
