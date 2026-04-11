# EDOPro is a fan-made Yu-Gi-Oh! simulator. This module produces a nix-ified
# version of the .desktop file EDOPro ships with.
#
# The game must be downloaded manually to `installPath`. As the game is not
# built with installing on an immutable file-system in mind, packaging the
# download using Nix feels a bit pointless.
#
# Download URL: https://projectignis.github.io/download.html
{ config, ... }:
let
  persistentStateDir = "/persist/state${config.home.homeDirectory}";
in
{
  satellite.games.entries.edopro = {
    name = "EDOPro";
    developers = [ "Project Ignis team" ];
    description = "EDOPro is an automatic Yu-Gi-Oh! dueling simulator.";

    file = "${persistentStateDir}/yugioh/.local/share/edopro/EDOPro";
    script = "steam-run";

    assets = {
      poster = ./assets/edopro/grid.png;
      logo = ./assets/edopro/logo.png;
      icon = ./assets/edopro/icon.png;
      background = ./assets/edopro/background.png;
      screenshot = ./assets/edopro/screenshot.png;
    };
  };
}
