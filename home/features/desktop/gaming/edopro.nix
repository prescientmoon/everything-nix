# Download URL: https://projectignis.github.io/download.html
{ config, ... }:
{
  satellite.games.entries.edopro = {
    name = "EDOPro";
    developers = [ "Project Ignis team" ];
    description = "EDOPro is an automatic Yu-Gi-Oh! dueling simulator.";

    file = "edopro/EDOPro";
    script = "steam-run";

    assets = {
      poster = ./assets/edopro/grid.png;
      logo = ./assets/edopro/logo.png;
      icon = ./assets/edopro/icon.png;
      background = ./assets/edopro/background.png;
    };
  };
}
