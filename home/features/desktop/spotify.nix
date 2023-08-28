{ inputs, pkgs, config, lib, ... }:
let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  themeMap = lib.fix (self: {
    "Catppuccin Mocha" = spicePkgs.themes.catppuccin-mocha;
    "Catppuccin Latte" = spicePkgs.themes.catppuccin-latte;
    "Catppuccin Frappe" = spicePkgs.themes.catppuccin-frappe;
    "Catppuccin Macchiato" = spicePkgs.themes.catppuccin-macchiato;

    default.light = self."Catppuccin Latte";
    default.dark = self."Catppuccin Macchiato";
  });
in
{
  programs.spicetify = {
    enable = true;

    theme = config.satellite.theming.get themeMap;

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplayMod
      shuffle # Working shuffle
      keyboardShortcut
      skipStats # Track my skips
      listPlaylistsWithSong # Adds button to show playlists which contain a song
      playlistIntersection # Shows stuff that's in two different playlists
      fullAlbumDate
      bookmark
      trashbin
      groupSession
      wikify # Shows an artist's wikipedia entry
      songStats
      showQueueDuration
      genre
      adblock
      savePlaylists # Adds a button to duplicate playlists
    ];
  };

  # TODO: persistence
}
