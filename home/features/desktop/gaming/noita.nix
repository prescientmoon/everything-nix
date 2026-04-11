{ config, lib, ... }:
let
  heroicGameDir = "${config.home.homeDirectory}/media/games/heroic";
  noitaGifDir = lib.concatStrings [
    config.xdg.dataHome
    "/heroic/prefixes/default/Noita"
    "/drive_c/users/moon/AppData/LocalLow/Nolla_Games_Noita"
    "/save_rec/screenshots_animated/"
  ];
in
{
  satellite.games.entries.noita = {
    name = "Noita";
    developers = [ "Nolla Games" ];
    release = "2020-10-15";
    description = ''
      Noita is a magical action roguelite set in a world where every pixel is
      physically simulated. Fight, explore, melt, burn, freeze and evaporate your
      way through the procedurally generated world using spells you've created
      yourself.
    '';

    # TODO(2026-04-11): move this out of heroic's dir
    file = "${heroicGameDir}/Noita/noita.exe";
    script = "umu";

    assets = {
      poster = ./assets/noita/grid.png;
      logo = ./assets/noita/logo.png;
      icon = ./assets/noita/icon.png;
      background = ./assets/noita/background.png;
      screenshot = ./assets/noita/screenshot.jpg;
    };
  };

  # TODO(2025-11-22): auto-convert Noita's GIFs to a better format
  # TODO(2025-12-16): move prefix to its own subdirectory
  systemd.user.tmpfiles.rules = [
    # Make Noita's GIFs more easily accessible
    "L+ ${config.xdg.userDirs.videos}/noita - - - - ${noitaGifDir}"
  ];
}
