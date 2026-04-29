{ config, ... }:
let
  persistentStateDir = "/persist/state${config.home.homeDirectory}";
  dir = "${persistentStateDir}/touhou";
in
{
  satellite.games.entries.touhou06 = {
    name = "Touhou 6: Koumakyou - The Embodiment of Scarlet Devil";
    developers = [ "Team Shanghai Alice" ];
    release = "2002-09-22";
    description = ''
      A thick scarlet mist is covering Gensokyo; it blocks out the sun, which
      causes affected areas to become cold. Our heroines believe the culprit
      lives in the newly-materialized Scarlet Devil Mansion, and so they depart
      with the goal of “questioning” those who live there.
    '';

    file = "${dir}/06/th06e.exe";
    winePrefix = "${dir}/prefix";
    script = "umu";

    assets = {
      poster = ./assets/touhou06/grid.jpg;
      logo = ./assets/touhou06/logo.png;
      icon = ./assets/touhou06/icon.jpg;
      background = ./assets/touhou06/background.jpg;
    };
  };
}
