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

    # obs-studio # video recorder
    # lmms # music software
  ];

  satellite-dev.enable = true;
}
