{
  config,
  pkgs,
  lib,
  ...
}:
let
  elisa = pkgs.kdePackages.elisa;
in
{
  home.packages = [ elisa ];

  xdg.configFile.elisarc.source = # .
    config.satellite.dev.path "home/features/desktop/elisa/elisarc";

  satellite.persistence.at.cache.apps.elisa.directories = [
    "${config.xdg.dataHome}/elisa"
    "${config.xdg.cacheHome}/elisa"
  ];

  xdg.desktopEntries.elisa-fresh = {
    name = "Elisa (with fresh DB)";
    type = "Application";
    icon = "elisa";
    terminal = false;
    exec = toString (
      pkgs.writeShellScript "elisa-with-fresh-db" ''
        rm -rf ${config.xdg.dataHome}/elisa/*
        rm -rf ${config.xdg.cacheHome}/elisa/*
        ${lib.getExe elisa}
      ''
    );
  };
}
