{ config, ... }:
let
  persistentStateDir = "/persist/state${config.home.homeDirectory}";
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

    file = "${persistentStateDir}/braid/steam-install/braid64_d3d11_final.exe";
    script = "umu";

    assets = {
      poster = ./assets/braid/grid.png;
      logo = ./assets/braid/logo.png;
      icon = ./assets/braid/icon.png;
      background = ./assets/braid/background.jpg;
      screenshot = ./assets/braid/screenshot.jpg;
    };
  };
}
