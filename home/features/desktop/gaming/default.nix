{ config, pkgs, ... }:
{
  home.packages = [ pkgs.vvvvvv ];

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
