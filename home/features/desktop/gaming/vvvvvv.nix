{ config, pkgs, ... }:
{
  satellite.games.entries.vvvvvv = {
    name = "VVVVVV";
    developers = [ "Terry Cavanagh" ];
    release = "2010-09-08";
    description = ''
      VVVVVV is a platform game all about exploring one simple mechanical
      idea - what if you reversed gravity instead of jumping?
    '';

    filePath = "${pkgs.vvvvvv}/bin/vvvvvv";
    paths = [ "${config.xdg.dataHome}/VVVVVV" ];

    assets = {
      poster = ./assets/vvvvvv/grid.png;
      logo = ./assets/vvvvvv/logo.png;
      icon = ./assets/vvvvvv/icon.png;
      background = ./assets/vvvvvv/background.png;
    };
  };
}
