{ config, ... }:
let
  home = "/persist/data${config.users.users.pilot.home}";
in
{
  services.syncthing = {
    settings.folders = {
      "pebbles" = {
        path = "${home}/media/music/pebbles";
        devices = [
          "chaldene"
          "calypso"
        ];
      };

      "moonythm" = {
        path = "${home}/projects/personal/angelfold/moonythm/moonythm/content";
        devices = [
          "chaldene"
          "calypso"
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
          "calypso"
          "chaldene"
          "lapetus"
        ];
      };
    };
  };
}
