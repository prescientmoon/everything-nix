{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ./global
    ./features/desktop/xmonad.nix
    ./features/desktop/common/discord.nix
    ./features/desktop/common/signal.nix
    ./features/desktop/common/qbittorrent.nix
    ./features/desktop/common/zathura.nix
    ./features/desktop/common/firefox.nix
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
  xsession.initExtra = ''
    command -v dbus-update-activation-environment >/dev/null 2>&1 && dbus-update-activation-environment --systemd XDG_SESSION_CLASS XDG_CONFIG_DIRS XDG_DATA_DIRS XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP XDG_SESSION_TYPE DCONF_PROFILE XDG_DESKTOP_PORTAL_DIR DISPLAY WAYLAND_DISPLAY SWAYSOCK XMODIFIERS XCURSOR_SIZE XCURSOR_THEME GDK_PIXBUF_MODULE_FILE GIO_EXTRA_MODULES GTK_IM_MODULE QT_PLUGIN_PATH QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE QT_IM_MODULE NIXOS_OZONE_WL || systemctl --user import-environment XDG_SESSION_CLASS XDG_CONFIG_DIRS XDG_DATA_DIRS XDG_SESSION_DESKTOP XDG_CURRENT_DESKTOP XDG_SESSION_TYPE DCONF_PROFILE XDG_DESKTOP_PORTAL_DIR DISPLAY WAYLAND_DISPLAY SWAYSOCK XMODIFIERS XCURSOR_SIZE XCURSOR_THEME GDK_PIXBUF_MODULE_FILE GIO_EXTRA_MODULES GTK_IM_MODULE QT_PLUGIN_PATH QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE QT_IM_MODULE NIXOS_OZONE_WL
  '';
}
