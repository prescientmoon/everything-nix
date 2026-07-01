{ config, ... }:
let
  persistentStateDir = "/persist/state${config.home.homeDirectory}";
  dir = "${persistentStateDir}/system-erasure";
in
{
  satellite.games.entries.void-stranger = {
    name = "Void Stranger";
    developers = [ "System Erasure" ];
    release = "2023-09-01";
    description = ''
      Place your faith and embrace the Void.
    '';

    file = "${dir}/void-stranger/VoidStranger.exe";
    winePrefix = "${dir}/prefix";
    script = "wine";

    assets = {
      poster = ./assets/void-stranger/grid.jpg;
      logo = ./assets/void-stranger/logo.png;
      icon = ./assets/void-stranger/icon.png;
      background = ./assets/void-stranger/background.jpg;
      screenshot = ./assets/void-stranger/screenshot.jpg;
    };
  };

  satellite.games.entries.zero-ranger = {
    name = "Zero Ranger";
    developers = [ "System Erasure" ];
    release = "2018-09-28";
    description = ''
      This is the story of a fighter who wanted to become...
    '';

    file = "${dir}/zero-ranger/ZeroRanger.exe";
    winePrefix = "${dir}/prefix";
    script = "wine";

    assets = {
      poster = ./assets/zero-ranger/grid.jpg;
      logo = ./assets/zero-ranger/logo.png;
      icon = ./assets/zero-ranger/icon.png;
      # background = ./assets/void-stranger/background.jpg;
      # screenshot = ./assets/void-stranger/screenshot.jpg;
    };
  };
}
