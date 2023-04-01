{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./global
    ./features/desktop/xmonad.nix
    ./features/desktop/common/discord.nix
    ./features/desktop/common/zathura.nix
    ./features/desktop/common/firefox.nix
  ];

  # Arbitrary extra packages
  home.packages = with pkgs; [
    # Desktop apps
    signal-desktop # Signal client
    zoom-us # Zoom client 🤮
    obsidian # Notes
    peek # GIF recorder
    vlc # Video player
    gimp # Image editing
    libreoffice # Free office suite
    lmms # Music software
    kicad # PCB editing
    # obs-studio # video recorder

    # Clis
    agenix # Secret encryption
    sherlock # Search for usernames across different websites
  ];

  home.sessionVariables.QT_SCREEN_SCALE_FACTOR = 1.4; # Bigger text in qt apps
  satellite.dev.enable = true; # Simlink some stuff outside the store
}
