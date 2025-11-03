{ config, ... }:
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

        devices = [
          "enceladus"
          "lapetus"
          "tethys"
        ];
      };
    };
  };
}
