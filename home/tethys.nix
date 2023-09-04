{ pkgs, ... }: {
  imports = [
    ./global

    ./features/desktop/zathura.nix
    ./features/desktop/spotify.nix
    ./features/desktop/firefox
    ./features/desktop/discord
    ./features/cli/productivity
    ./features/cli/khal.nix
    ./features/cli/pass.nix
    ./features/neovim

    # ./features/xorg/xmonad.nix
    ./features/wayland/hyprland
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
    plover.dev # steno engine
    qbittorrent # Torrent client
    signal-desktop # Signal client
    wine # Windows compat layer or whatever
    lutris # Game launcher
    # google-chrome # Not my primary browser, but sometimes needed in webdev
    # obs-studio # video recorder

    # Clis
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
      at.data.prefixDirectories = false;

      # App state I want to keep
      at.state.path = "/persist/state";

      # App state which I should be able to delete at any point
      at.cache.path = "/persist/local/cache";
    };
  };

  monitors = [{
    name = "eDP-1";
    width = 1920;
    height = 1080;
  }];
}
