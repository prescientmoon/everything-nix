{ config, pkgs, ... }:
{
  home.packages = [ pkgs.kdePackages.elisa ];

  xdg.configFile.elisarc.source = # .
    config.satellite.dev.path "home/features/desktop/elisa/elisarc";

  satellite.persistence.at.cache.apps.elisa.directories = [
    "${config.xdg.dataHome}/elisa"
    "${config.xdg.cacheHome}/elisa"
  ];
}
