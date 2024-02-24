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
      CF_APP_ALLOWREGISTRATIONS = "false"; # I already made an account

      # I randomly generated an user agent for this
      CF_APP_USERAGENT = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0_6; like Mac OS X) AppleWebKit/533.48 (KHTML, like Gecko)  Chrome/49.0.2557.162 Mobile Safari/602.0";
    };
  };
}
