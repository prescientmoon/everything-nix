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

    file = "${pkgs.vvvvvv}/bin/vvvvvv";
    assets = {
      poster = ./assets/vvvvvv/grid.png;
      logo = ./assets/vvvvvv/logo.png;
      icon = ./assets/vvvvvv/icon.png;
      background = ./assets/vvvvvv/background.png;
      screenshot = ./assets/vvvvvv/screenshot.jpg;
    };
  };

  satellite.persistence.at.state.apps.vvvvvv.directories = [
    {
      directory = "${config.xdg.dataHome}/VVVVVV";
      method = "symlink";
    }
  ];
}
