{ config, ... }:
let
  persistentStateDir = "/persist/state${config.home.homeDirectory}";
  dir = "${persistentStateDir}/gridsage";
in
{
  satellite.games.entries.cogmind = {
    name = "Cogmind";
    file = "${dir}/cogmind/COGMIND.exe";
    winePrefix = "${dir}/prefix";
    script = "umu";

    assets = {
      poster = ./assets/cogmind/grid.jpg;
      icon = ./assets/cogmind/icon.png;
    };
  };
}
