{ pkgs, upkgs, ... }:
{
  imports = [
    ./discord
    ./firefox
    ./elisa

    ./amberol.nix
    ./dunst.nix
    ./foot.nix
    ./inlyne.nix
    ./monitors.nix
    ./mpv.nix
    ./obsidian.nix
    ./spotify.nix
    ./zathura.nix
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

  # We technically don't want this on non TWMs, but I don't use any such WMs
  home.sessionVariables.GTK_CSD = 0;

  # Base packages
  home.packages = with pkgs; [
    anki # flashcards!
    aseprite # pixel art
    bitwarden-desktop # Password-manager
    dig # DNS queries
    element-desktop # Matrix client
    ffmpeg # Video operations
    fluffychat # Matrix client
    gimp # Image editing
    gnome-calendar
    gnome-control-center # Required for configuring calendar accounts
    imagemagick # Image operations
    imv # Image viewer
    krita # drawing
    lagrange # Gemini browser
    libreoffice # document editing
    obs-studio # video recorder
    overskride # Bluetooth client
    qbittorrent # Torrent client
    sherlock # Search for usernames across different websites
    sqlite # I sometimes need to check the databases owned by various apps
    termdown # Basic CLI timer
    wasistlos # Whatsapp
    yt-dlp # I often download live streams I can't watch in the moment

    # NOTE: "expired" versions can no longer be used
    upkgs.signal-desktop # Signal client
  ];
}
