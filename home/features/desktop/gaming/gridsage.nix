{ config, ... }:
{
  satellite.games.entries.cogmind = {
    name = "Cogmind";
    file = "cogmind/COGMIND.exe";
    script = "umu";

    assets = {
      poster = ./assets/cogmind/grid.jpg;
      icon = ./assets/cogmind/icon.png;
    };
  };
}
