{ config, lib, ... }:
let
  cfg = config.satellite.wireless;
in
{
  config = lib.mkIf (cfg.enable && cfg.backend == "network-manager") {
    assertions = [
      {
        assertion = cfg.active;
        message = "The network-manager module does not support inactive mode.";
      }
    ];

    users.users.pilot.extraGroups = [ "networkmanager" ];
    networking.networkmanager.enable = true;
  };
}
