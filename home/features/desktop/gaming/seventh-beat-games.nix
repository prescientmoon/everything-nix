{ config, ... }:
let
  persistentStateDir = "/persist/state${config.home.homeDirectory}";
  dir = "${persistentStateDir}/seventh-beat-games";
in
{
  satellite.games.entries.rhythm-doctor = {
    name = "Rhythm Doctor";
    developers = [ "7th Beat Games" ];
    release = "2025-12-07";
    description = ''
      Save patients with your rhythm mastery! Rhythm Doctor is a rhythm game
      where you heal patients by defibrillating in time to their heartbeats.
      Learn each patient's unique heartbeat and defeat boss viruses trying to
      sabotage your rhythm, all set to heart-pumping, soul-soothing music.
    '';

    file = "${dir}/rhythm-doctor/Rhythm Doctor";
    script = "steam-run";
    # file = "${dir}/rhythm-doctor/windows/Rhythm Doctor.exe";
    # winePrefix = "${dir}/prefix";
    # script = "wine";

    assets = {
      poster = ./assets/rhythm-doctor/grid.jpg;
      logo = ./assets/rhythm-doctor/logo.png;
      icon = ./assets/rhythm-doctor/icon.png;
    };
  };

  satellite.persistence.at.state.apps.seventh-beat-games.directories = [
    {
      directory = "${config.xdg.configHome}/unity3d/7th Beat Games/Rhythm Doctor";
      method = "symlink";
    }
  ];
}
