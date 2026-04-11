{ config, lib, ... }:
{
  sops.secrets.syncthing_key.sopsFile = ../secrets.yaml;
  sops.secrets.syncthing_cert.sopsFile = ../secrets.yaml;

  services.syncthing = {
    key = config.sops.secrets.syncthing_key.path;
    cert = config.sops.secrets.syncthing_cert.path;

    settings.folders = {
      "stellar-sanctum" = {
        path = "/persist/data${config.users.users.pilot.home}/projects/personal/stellar-sanctum";

        versioning = {
          type = "staggered";
          params = {
            cleanInterval = "3600"; # 1 hour in seconds
            maxAge = "604800"; # 14 days in seconds.
          };
        };

        devices = [ "calypso" ];
      };
    };
  };

  # Expose my phone's web UI via nginx
  satellite.nginx.at."syncthing.chaldene".vhost.locations."/" = {
    proxyWebsockets = true;
    proxyPass = lib.concatStrings [
      "http://chaldene.overlay"
      ".${config.satellite.dns.domain}"
      ":${toString config.satellite.ports.syncthing}"
    ];
  };
}
