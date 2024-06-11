{ config, ... }:
let
  port = 8408;
  host = "actual.moonythm.dev";
  dataDir = "/persist/state/var/lib/actual";
in
{
  imports = [
    ../../common/optional/services/nginx.nix
    ../../common/optional/oci.nix
  ];

  services.nginx.virtualHosts.${host} = config.satellite.proxy port { };
  systemd.tmpfiles.rules = [ "d ${dataDir}" ];

  virtualisation.oci-containers.containers.actual = {
    image = "actualbudget/actual-server:latest";
    autoStart = true;

    ports = [ "${toString port}:5006" ]; # server:docker
    volumes = [ "${dataDir}:/data" ]; # server:docker
  };
}
