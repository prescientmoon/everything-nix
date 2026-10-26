{ config, ... }:
{
  satellite.games.entries.void-stranger = {
    name = "Void Stranger";
    developers = [ "System Erasure" ];
    release = "2023-09-01";
    description = "Place your faith and embrace the Void.";

    script = "wine";
    file = "steam/VoidStranger.exe";
    paths = [ "AppData/Local/void_stranger" ];

    assets = {
      poster = ./assets/void-stranger/grid.jpg;
      logo = ./assets/void-stranger/logo.png;
      icon = ./assets/void-stranger/icon.png;
      background = ./assets/void-stranger/background.jpg;
    };
  };

  satellite.games.entries.zero-ranger = {
    name = "Zero Ranger";
    developers = [ "System Erasure" ];
    release = "2018-09-28";
    description = ''
      This is the story of a fighter who wanted to become...
    '';

    script = "wine";
    file = "itch/ZeroRanger.exe";
    paths = [ "AppData/Local/ZeroRanger" ];

    assets = {
      poster = ./assets/zero-ranger/grid.jpg;
      logo = ./assets/zero-ranger/logo.png;
      icon = ./assets/zero-ranger/icon.png;
    };
  };

  satellite.games.entries.zero-ranger-trainer = {
    inherit (config.satellite.games.entries.zero-ranger)
      assets file historiaId paths prefix script state wine;

    pegasus = false;
    name = "Zero Ranger (ZeroTrainer)";
    args = [
      "-game"
      "${config.satellite.games.state}/zero-ranger/itch/data-steam-zt.win"
    ];
  };

  satellite.games.entries.zero-ranger-dora = {
    inherit (config.satellite.games.entries.zero-ranger)
      assets file historiaId paths script state;

    pegasus = false;
    name = "Zero Ranger (Dora)";
    prefix = "prefix-dora";
  };
}
