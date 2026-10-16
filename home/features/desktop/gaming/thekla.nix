{ config, ... }:
let
  persistentStateDir = config.satellite.persistence.at.state.bounds.source;
  dir = "${persistentStateDir}/thekla";
  winePrefix = "${dir}/prefix";
in
{
  satellite.games.entries.braid = {
    name = "Braid";
    developers = [ "Number None" ];
    release = "2008-08-06";
    description = ''
      Control the flow of time to solve puzzles in this new version of the 
      indie classic, featuring fully repainted artwork, a new world of 
      puzzles, and seriously in-depth commentary.
    '';

    script = "umu";
    file = "${dir}/braid-steam-install/braid64_d3d11_final.exe";
    inherit winePrefix;

    assets = {
      poster = ./assets/braid/grid.png;
      logo = ./assets/braid/logo.png;
      icon = ./assets/braid/icon.png;
      background = ./assets/braid/background.jpg;
      screenshot = ./assets/braid/screenshot.jpg;
    };
  };

  satellite.games.entries.ootss = {
    name = "Order of the Sinking Star";

    script = "umu";
    file = "${winePrefix}/drive_c/users/moon/Games/Order of the Sinking Star/sinking_star.exe";
    inherit winePrefix;

    assets = {
      poster = ./assets/ootss/grid.jpg;
      icon = ./assets/ootss/icon.png;
      background = ./assets/ootss/background.jpg;
      screenshot = ./assets/ootss/screenshot.jpg;
    };
  };
}
