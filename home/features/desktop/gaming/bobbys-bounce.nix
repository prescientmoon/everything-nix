{ config, ... }:
let
  persistentStateDir = config.satellite.persistence.at.state.bounds.source;
in
{
  satellite.games.entries.bobbys-bounce = {
    name = "bobby's bounce";
    developers = [ "siloricity" ];
    release = "2026-04-12";

    file = "${persistentStateDir}/bobbys-bounce/game";
    script = "steam-run";

    assets = {
      poster = ./assets/bobbys-bounce/grid.png;
      icon = ./assets/bobbys-bounce/icon.png;
      background = ./assets/bobbys-bounce/background.jpg;
      screenshot = ./assets/bobbys-bounce/screenshot.jpg;
    };
  };

  satellite.persistence.at.state.at.bobbys-bounce.directories = [
    "${config.xdg.dataHome}/godot/app_userdata/bobbys-bounce"
  ];
}
