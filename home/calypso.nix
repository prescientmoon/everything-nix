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
    # Communication
    wasistlos
    element-desktop # Matrix client
    # zoom-us # Zoom client 🤮
    # NOTE: "expired" versions can no longer be used
    upkgs.signal-desktop # Signal client

    # Documents & editors
    kdePackages.okular # Useful for reading pdf annotations (which zathura does not support)
    # lmms # Music software
    # kicad # PCB editing

    # Clis
    sherlock # Search for usernames across different websites
    termdown # Basic CLI timer

    # Misc
    # google-chrome # Not my primary browser, but sometimes needed in webdev
    # plover.dev # steno engine
    upkgs.freetube # youtube client
    pomodoro-gtk # basic pomodoro timer
    anki # flashcards!
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
