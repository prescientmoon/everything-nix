{ config, ... }:
let
  home = "/persist/data${config.users.users.pilot.home}";
in
{
  sops.secrets.syncthing_key.sopsFile = ../secrets.yaml;
  sops.secrets.syncthing_cert.sopsFile = ../secrets.yaml;

  services.syncthing = {
    key = config.sops.secrets.syncthing_key.path;
    cert = config.sops.secrets.syncthing_cert.path;

    settings.folders = {
      "pebbles" = {
        path = "${home}/media/music/pebbles";
        devices = [
          "chaldene"
        ];
      };

      "stellar-sanctum" = {
        path = "${home}/projects/personal/stellar-sanctum";

        versioning = {
          type = "staggered";
          params = {
            cleanInterval = "3600"; # 1 hour in seconds
            maxAge = "604800"; # 14 days in seconds.
          };
        };

        devices = [
          "lapetus"
          "chaldene"
        ];
      };
    };
  };
}
