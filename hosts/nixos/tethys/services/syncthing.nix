{ config, ... }:
{
  services.syncthing = {
    settings.folders = {
      "stellar-sanctum" = {
        path = "${config.users.users.pilot.home}/projects";

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
          "calypso"
        ];
      };
    };
  };
}
