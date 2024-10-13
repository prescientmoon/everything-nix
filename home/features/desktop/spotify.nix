{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  themeMap = lib.fix (self: {
    "Catppuccin Mocha" = spicePkgs.themes.comfy;
    "Catppuccin Latte" = spicePkgs.themes.comfy;
    "Catppuccin Frappe" = spicePkgs.themes.comfy;
    "Catppuccin Macchiato" = spicePkgs.themes.comfy;

    default.light = self."Catppuccin Latte";
    default.dark = self."Catppuccin Macchiato";
  });

  colorschemeMap = lib.fix (self: {
    "Catppuccin Mocha" = "catppuccin-mocha";
    "Catppuccin Latte" = "catppuccin-latte";
    "Catppuccin Frappe" = "catppuccin-frappe";
    "Catppuccin Macchiato" = "catppuccin-macchiato";

    default.light = self."Catppuccin Latte";
    default.dark = self."Catppuccin Macchiato";
  });
in
{
  imports = [ ./audio.nix ];
  home.packages = [ pkgs.spot ];

  programs.spicetify = {
    enable = true;

    theme = config.satellite.theming.get themeMap;
    colorScheme = config.satellite.theming.get colorschemeMap;

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      betterGenres
      bookmark
      fullAlbumDate
      fullAppDisplayMod
      groupSession
      keyboardShortcut
      listPlaylistsWithSong # Adds button to show playlists which contain a song
      playlistIntersection # Shows stuff that's in two different playlists
      savePlaylists # Adds a button to duplicate playlists
      showQueueDuration
      shuffle # Working shuffle
      skipStats # Track my skips
      songStats
      trashbin
      wikify # Shows an artist's wikipedia entry
    ];
  };

  # {{{ Persistence
  satellite.persistence.at.state.apps.spotify.directories = [ "${config.xdg.configHome}/spotify" ];

  satellite.persistence.at.cache.apps.spotify.directories = [ "${config.xdg.cacheHome}/spotify" ];
  # }}}
}
