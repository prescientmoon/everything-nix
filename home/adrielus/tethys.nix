{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./global
    ./features/desktop/xmonad.nix
    ./features/desktop/common/discord.nix
    ./features/desktop/common/zathura.nix
    ./features/desktop/common/firefox.nix
  ];

  home.packages = with pkgs; [
    signal-desktop # Signal client
    zoom-us # Zoom client 🤮
    obsidian # Notes
    peek # GIF recorder
    vlc # Video player
    gimp # Image editing
    libreoffice # Free office suite
    lmms # music software

    # obs-studio # video recorder
  ];

  home.sessionVariables.QT_SCREEN_SCALE_FACTOR = 1.4; # Bigger text in qt apps
  satellite-dev.enable = true; # Simlink some stuff outside the store
}
