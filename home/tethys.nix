{ pkgs, ... }:
{
  imports = [
    ./global.nix

    ./features/cli/catgirl.nix
    ./features/cli/lazygit.nix
    ./features/cli/nix-index.nix
    ./features/cli/productivity
    ./features/cli/zellij.nix
    ./features/desktop/discord
    ./features/desktop/firefox
    ./features/desktop/foot.nix
    ./features/desktop/obsidian.nix
    ./features/desktop/spotify.nix
    ./features/desktop/zathura.nix
    ./features/wayland/hyprland
    ./features/neovim
  ];

  # Arbitrary extra packages
  home.packages = with pkgs; [
    # {{{ Communication
    # signal-desktop # Signal client
    element-desktop # Matrix client
    # zoom-us # Zoom client 🤮
    # }}}
    # {{{ Editors for different formats
    gimp # Image editing
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

    overskride # Bluetooth client
    # }}}
    # {{{ Media playing/recording
    mpv # Video player
    imv # Image viewer
    # peek # GIF recorder
    # obs-studio # video recorder
    # }}}
  ];

  home.sessionVariables.QT_SCREEN_SCALE_FACTORS = 1.4; # Bigger text in qt apps
  home.stateVersion = "23.05";

  satellite = {
    # Symlink some commonly modified dotfiles outside the nix store
    dev.enable = true;

    monitors = [
      {
        name = "eDP-1";
        width = 1920;
        height = 1080;
      }
    ];
  };
}
