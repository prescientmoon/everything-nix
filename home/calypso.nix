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

  home.stateVersion = "24.05";
  home.username = "moon";

  # Arbitrary extra packages
  home.packages = with pkgs; [
    # Communication
    whatsapp-for-linux
    # signal-desktop # Signal client
    # element-desktop # Matrix client
    # zoom-us # Zoom client 🤮

    # Documents & editors
    libsForQt5.okular # Useful for reading pdf annotations (which zathura does not support)
    # lmms # Music software
    # kicad # PCB editing
    # libreoffice # Free office suite

    # Clis
    # sherlock # Search for usernames across different websites

    # Misc
    # google-chrome # Not my primary browser, but sometimes needed in webdev
    # plover.dev # steno engine
    freetube # youtube client
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
