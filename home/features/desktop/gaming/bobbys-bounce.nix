{ config, ... }:
let
  persistentStateDir = "/persist/state${config.home.homeDirectory}";
in
{
  satellite.games.entries.bobbys-bounce = {
    name = "bobby's bounce";
    developers = [ "siloricity" ];
    release = "2026-04-12";

    file = "${persistentStateDir}/bobbys-bounce/game";
    script = "steam-run";

    assets = {
      icon = ./assets/bobbys-bounce/icon.png;
      background = ./assets/bobbys-bounce/background.jpg;
      screenshot = ./assets/bobbys-bounce/screenshot.jpg;
    };
  };

  satellite.persistence.at.state.apps.bobbys-bounce.directories = [
    {
      directory = "${config.xdg.dataHome}/godot/app_userdata/bobbys-bounce";
      method = "symlink";
    }
  ];
}
