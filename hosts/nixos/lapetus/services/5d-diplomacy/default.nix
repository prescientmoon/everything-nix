{ config, ... }:
{
  imports = [ ./generated.nix ];

  satellite.cloudflared.at.dip.port = config.satellite.ports."5d-diplomacy";
  virtualisation.oci-containers.containers."5d-diplomacy-frontend".ports = [
    "${toString config.satellite.ports."5d-diplomacy"}:8080"
  ];
}
