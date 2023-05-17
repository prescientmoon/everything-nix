{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./global
    ./features/desktop/xmonad.nix
    ./features/desktop/common/discord.nix
    ./features/desktop/common/signal.nix
    ./features/desktop/common/qbittorrent.nix
    ./features/desktop/common/zathura.nix
    ./features/desktop/common/firefox
    ./features/games
  ];

  # Arbitrary extra packages
  home.packages = with pkgs; [
    # Desktop apps
    zoom-us # Zoom client 🤮
    element-desktop # Matrix client
    obsidian # Notes
    peek # GIF recorder
    vlc # Video player
    gimp # Image editing
    libreoffice # Free office suite
    lmms # Music software
    kicad # PCB editing
    # google-chrome # Not my primary browser, but sometimes needed in webdev
    # obs-studio # video recorder

    # Clis
    agenix # Secret encryption
    sherlock # Search for usernames across different websites
  ];

  home.sessionVariables.QT_SCREEN_SCALE_FACTORS = 1.4; # Bigger text in qt apps

  satellite = {
    # Simlink some commonly modified dotfiles outside the store
    dev.enable = true;

    # Set up my custom imperanence wrapper
    persistence = {
      enable = true;

      # Actual data/media (eg: projects, images, videos, etc)
      at.data.path = "/persist/data";

      # App state I want to keep
      at.state.path = "/persist/state";

      # App state which I should be able to delete at any point
      at.cache.path = "/persist/cache";
    };
  };


  # Temp stuff
  # systemd.servinces.dbus-update-activation-environment = {
  #   script = lib.escapeShellArgs "${pkgs.dbu}/bin/dbus-update-activation-environment --systemd --all";
  #   serviceConfig.Restart = "no";
  #   serviceConfig.User = config.home.user;
  # };
  xsession.initExtra = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all";
}
