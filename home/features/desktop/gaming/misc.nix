{ config, ... }:
let
  persistentStateDir = config.satellite.persistence.at.state.bounds.source;
  dir = "${persistentStateDir}/misc-games";
in
{
  satellite.games.entries.grapplehook-midpoint-teleport-killer = {
    name = "Grapplehook Midpoint Teleport Killer";
    developers = [ "Love ♥  Game" ];
    release = "2026-09-07";
    description = ''
      In this platformer game, Sylvie has a fluffy tail and can teleport to the
      midpoint of her Grapplehook. What could possibly go wrong? And does this
      world truly have a kitten?
    '';

    file = "${dir}/grapplehook-midpoint-teleport-killer/GMTK.exe";
    script = "wine";

    wine.state = "${dir}/grapplehook-midpoint-teleport-killer/prefix";
    wine.paths = [ "AppData/Local/GMTK" ];

    assets = {
      icon = ./assets/grapplehook-midpoint-teleport-killer/icon.png;
    };
  };

  satellite.games.entries.bobbys-bounce = {
    name = "bobby's bounce";
    developers = [ "siloricity" ];
    release = "2026-04-12";

    file = "${dir}/bobbys-bounce/game";
    script = "steam-run";

    assets = {
      poster = ./assets/bobbys-bounce/grid.png;
      icon = ./assets/bobbys-bounce/icon.png;
      background = ./assets/bobbys-bounce/background.jpg;
      screenshot = ./assets/bobbys-bounce/screenshot.jpg;
    };
  };

  satellite.persistence.at.state.at."misc-games/bobbys-bounce".directories = [
    "${config.xdg.dataHome}/godot/app_userdata/bobbys-bounce"
  ];
}
