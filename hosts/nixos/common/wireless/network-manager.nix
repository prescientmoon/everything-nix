{ config, lib, ... }:
let
  cfg = config.satellite.wireless;
in
{
  config = lib.mkIf (cfg.enable && cfg.backend == "network-manager") {
    users.users.pilot.extraGroups = [ "networkmanager" ];
    networking.networkmanager.enable = true;
  };
}
