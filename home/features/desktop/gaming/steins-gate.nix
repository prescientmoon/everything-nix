{ config, ... }:
let
  persistentStateDir = "/persist/state${config.home.homeDirectory}";
  dir = "${persistentStateDir}/science-adventure/steins-gate";
in
{
  satellite.games.entries.steins-gate = {
    name = "Steins;Gate";
    developers = [ "MAGES" ];
    release = "2009-10-15";
    description = ''
      -Decide The Fate Of All Mankind-\\n
      CAN YOU CHANGE THE COURSE OF FATE?\\n
      AND SAVE THE ONES CLOSEST TO YOU?\\n
    '';

    # The files I have from my Steam copy do not work by themselves, but a
    # bit of patching solved the issue.
    file = "${dir}/steam-install/Launcher.exe";
    winePrefix = "${dir}/prefix";
    script = "umu";

    assets = {
      poster = ./assets/steins-gate/grid.png;
      logo = ./assets/steins-gate/logo.png;
      icon = ./assets/steins-gate/icon.png;
      background = ./assets/steins-gate/background.jpg;
      screenshot = ./assets/steins-gate/screenshot.jpg;
    };
  };
}
