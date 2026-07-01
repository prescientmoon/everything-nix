{ pkgs, upkgs, ... }:
{
  imports = [
    ./global.nix

    ./features/desktop/gaming
    ./features/desktop/gaming/edopro.nix
    ./features/wayland/hyprland
    ./features/neovim
  ];

  home.stateVersion = "24.05";
  home.username = "moon";

  # Arbitrary extra packages
  home.packages = with pkgs; [
    # google-chrome # Not my primary browser, but sometimes needed for webdev
    # kicad # PCB editing
    # lmms # Music software
    # plover.dev # steno engine
    # kdePackages.okular # Useful for reading pdf annotations (which Zathura does not support)
    pomodoro-gtk # basic pomodoro timer
    upkgs.freetube # YouTube client
  ];

  satellite = {
    dev.enable = true; # Enable symlinks outside the nix store

    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1200;
      }
    ];
  };
}
