{ config, ... }:
let
  persistentStateDir = "/persist/state${config.home.homeDirectory}";
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
    winePrefix = "${dir}/prefix";
    script = "wine";

    assets = {
      icon = ./assets/grapplehook-midpoint-teleport-killer/icon.png;
    };
  };
}
