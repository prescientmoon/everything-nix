{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.ffmpeg
    (pkgs.python3.pkgs.beets.override {
      pluginOverrides.fetchart.enable = true;
      pluginOverrides.lyrics.enable = true;
      pluginOverrides.lastgenre.enable = true;
      pluginOverrides.embedart.enable = true;
    })
  ];

  xdg.configFile."beets/config.yaml".source =
    config.satellite.dev.path "home/features/cli/beets/config.yaml";

  satellite.persistence.at.state.apps.beets.directories = [
    "${config.xdg.dataHome}/beets"
  ];
}
