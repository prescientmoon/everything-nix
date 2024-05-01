{ pkgs, upkgs, lib, config, ... }: {
  imports = [
    ./global.nix

    ./features/desktop/zathura.nix
    ./features/desktop/spotify.nix
    ./features/desktop/obsidian.nix
    ./features/desktop/firefox
    ./features/desktop/discord
    ./features/cli/productivity
    ./features/cli/pass.nix
    ./features/cli/nix-index.nix
    ./features/cli/catgirl.nix
    ./features/cli/lazygit.nix
    ./features/wayland/hyprland
    ./features/neovim
  ];

  # Arbitrary extra packages
  home.packages = with pkgs; [
    # Desktop apps
    # {{{ Communication
    # signal-desktop # Signal client
    element-desktop # Matrix client
    # zoom-us # Zoom client 🤮
    # }}}
    # {{{ Editors for different formats 
    # gimp # Image editing
    # lmms # Music software
    # kicad # PCB editing
    # libreoffice # Free office suite
    # }}}
    # {{{ Gaming 
    # wine # Windows compat layer or whatever
    # lutris # Game launcher
    # }}}
    # {{{ Clis
    sops # Secret editing
    # sherlock # Search for usernames across different websites
    # }}}
    # {{{ Misc 
    bitwarden # Password-manager
    qbittorrent # Torrent client
    # google-chrome # Not my primary browser, but sometimes needed in webdev
    # plover.dev # steno engine

    # REASON: not available in nixpkgs-stable just yet
    upkgs.overskride # Bluetooth client
    # }}} 
    # {{{ Media playing/recording
    mpv # Video player
    imv # Image viewer
    # peek # GIF recorder
    # obs-studio # video recorder
    # }}}
  ];

  home.sessionVariables.QT_SCREEN_SCALE_FACTORS = 1.4; # Bigger text in qt apps

  satellite = {
    # Symlink some commonly modified dotfiles outside the nix store
    dev.enable = true;

    monitors = [{
      name = "eDP-1";
      width = 1920;
      height = 1080;
    }];
  };
}
