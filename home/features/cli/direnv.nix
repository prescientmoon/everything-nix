{ config, ... }:
let
  statePath = "${config.xdg.dataHome}/direnv/allow";
in
{
  programs.direnv.enable = true;
  programs.direnv.silent = true;
  programs.direnv.nix-direnv.enable = true;

  # Only save allowed paths for 30d
  systemd.user.tmpfiles.rules = [ "d ${statePath} - - - 30d" ];
  satellite.persistence.at.state.apps.direnv.directories = [ statePath ];
}
