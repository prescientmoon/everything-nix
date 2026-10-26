{ config, ... }:
{
  satellite.games.entries.grapplehook-midpoint-teleport-killer = {
    name = "Grapplehook Midpoint Teleport Killer";
    developers = [ "Love ♥ Game" ];
    release = "2026-09-07";
    description = ''
      In this platformer game, Sylvie has a fluffy tail and can teleport to the
      midpoint of her Grapplehook. What could possibly go wrong? And does this
      world truly have a kitten?
    '';

    script = "wine";
    file = "itch/GMTK.exe";
    paths = [ "AppData/Local/GMTK" ];

    assets = {
      icon = ./assets/grapplehook-midpoint-teleport-killer/icon.png;
    };
  };

  satellite.games.entries.bobbys-bounce = {
    name = "bobby's bounce";
    developers = [ "siloricity" ];
    release = "2026-04-12";

    script = "steam-run";
    file = "itch/game";
    paths = [ "${config.xdg.dataHome}/godot/app_userdata/bobby's bounce" ];

    assets = {
      poster = ./assets/bobbys-bounce/grid.png;
      icon = ./assets/bobbys-bounce/icon.png;
      background = ./assets/bobbys-bounce/background.jpg;
    };
  };
}
