{ config, ... }:
let
  port = 8413;
  host = "rss.moonythm.dev";
  dataDir = "/persist/state/var/lib/commarss";
in
{
  imports = [ ../../common/optional/services/nginx.nix ];

  systemd.tmpfiles.rules = [ "d ${dataDir}" ];
  services.nginx.virtualHosts.${host} = config.satellite.proxy port
    { proxyWebsockets = true; };

  virtualisation.oci-containers.containers.commarss = {
    image = "athou/commafeed:latest";
    autoStart = true;

    ports = [ "${toString port}:8082" ]; # server:docker
    volumes = [ "${dataDir}:/commafeed/data" ]; # server:docker

    # https://github.com/Athou/commafeed/blob/master/commafeed-server/config.yml.example
    environment = {
      CF_APP_PUBLICURL = "https://${host}";
    };
  };
}
