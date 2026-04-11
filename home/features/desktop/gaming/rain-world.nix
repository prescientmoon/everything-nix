{ config, ... }:
let
  steamDir = "${config.xdg.dataHome}/Steam";
  steamGameDir = "${steamDir}/steamapps/common";
in
{
  satellite.games.entries.rain-world = {
    name = "Rain World";
    developers = [
      "Videocult"
      "Akupara Games"
    ];
    release = "2017-03-28";
    description = ''
      You are a nomadic slugcat, both predator and prey in a broken ecosystem.
      Grab your spear and brave the industrial wastes, hunting enough food to
      survive, but be wary— other, bigger creatures have the same plan... and
      slugcats look delicious.
    '';

    file = "${steamGameDir}/Rain World/RainWorld.exe";
    script = "umu";

    assets = {
      poster = ./assets/rain-world/grid.png;
      logo = ./assets/rain-world/logo.png;
      icon = ./assets/rain-world/icon.png;
      background = ./assets/rain-world/background.png;
      screenshot = ./assets/rain-world/screenshot.png;
    };
  };
}
