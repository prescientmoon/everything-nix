{ config, pkgs, ... }:
{
  home.packages = [ pkgs.amberol ];
  satellite.persistence.at.cache.apps.amberol.directories = [
    "${config.xdg.cacheHome}/amberol"
  ];
}
