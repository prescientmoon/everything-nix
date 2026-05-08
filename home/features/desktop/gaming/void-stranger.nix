{ config, ... }:
let
  persistentStateDir = "/persist/state${config.home.homeDirectory}";
in
{
  satellite.games.entries.void-stranger = {
    name = "Void Stranger";
    developers = [ "System Erasure" ];
    release = "2023-09-01";
    description = ''
      Place your faith and embrace the Void.
    '';

    file = "${persistentStateDir}/void-stranger/steam-install/VoidStranger.exe";
    script = "wine";

    assets = {
      poster = ./assets/void-stranger/grid.jpg;
      logo = ./assets/void-stranger/logo.png;
      icon = ./assets/void-stranger/icon.png;
      background = ./assets/void-stranger/background.jpg;
      screenshot = ./assets/void-stranger/screenshot.jpg;
    };
  };
}
