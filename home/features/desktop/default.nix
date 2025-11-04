{ pkgs, ... }:
{
  imports = [
    ./dunst.nix
    ./discord
    ./firefox

    ./monitors.nix
    ./foot.nix
    ./obsidian.nix
    ./spotify.nix
    ./zathura.nix
    ./inlyne.nix
  ];

  # Notifies on low battery percentages
  services.batsignal.enable = true;

  # Use a base16 theme for gtk apps!
  stylix.targets.gtk.enable = true;
  gtk.enable = true;

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name = "Papirus";
  };

  # Bigger text in qt apps
  home.sessionVariables.QT_SCREEN_SCALE_FACTORS = 1.4;

  # Base packages
  home.packages = with pkgs; [
    gimp # Image editing
    krita # drawing
    libreoffice # document editing

    bitwarden # Password-manager
    qbittorrent # Torrent client
    overskride # Bluetooth client

    mpv # Video player
    imv # Image viewer
    obs-studio # video recorder
  ];
}
