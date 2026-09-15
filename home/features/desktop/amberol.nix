{ config, pkgs, ... }:
{
  home.packages = [ pkgs.amberol ];
  satellite.persistence.at.cache.at.amberol.directories = [
    "${config.xdg.cacheHome}/amberol"
  ];
}
