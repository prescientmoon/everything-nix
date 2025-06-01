{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.vvvvvv
    pkgs.lutris
  ];

  # {{{ Persistence
  satellite.persistence.at.state.apps.steam = {
    directories = [
      ".factorio"
      "${config.xdg.dataHome}/Steam"
      "${config.xdg.dataHome}/VVVVVV"
    ];
  };
  # }}}
}
