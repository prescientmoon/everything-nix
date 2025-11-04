{ ... }:
{
  imports = [
    ./global.nix

    ./features/desktop/gaming
    ./features/desktop/gaming/edopro.nix
    ./features/wayland/hyprland

    ./features/neovim
  ];

  home.stateVersion = "23.05";
  home.username = "adrielus";

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
