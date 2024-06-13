{ config, ... }:
let dataDir = "/persist/state/var/lib/actual";
in
{
  satellite.nginx.at.actual.port = config.satellite.ports.actual;
  systemd.tmpfiles.rules = [ "d ${dataDir}" ];

  virtualisation.oci-containers.containers.actual = {
    image = "actualbudget/actual-server:latest";
    autoStart = true;

    ports = [ "${toString config.satellite.nginx.at.actual.port}:5006" ]; # server:docker
    volumes = [ "${dataDir}:/data" ]; # server:docker
  };
}
