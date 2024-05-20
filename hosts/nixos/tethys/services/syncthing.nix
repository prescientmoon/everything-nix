{ config, ... }:
let commonVersioning = {
  type = "staggered";
  params = {
    cleanInterval = "3600"; # 1 hour in seconds
    maxAge = "604800"; # 14 days in seconds.
  };
};
in
{
  imports = [ ../../common/optional/services/syncthing.nix ];

  services.syncthing.settings.folders = {
    "stellar-sanctum" = {
      path = "${config.users.users.pilot.home}/projects/stellar-sanctum/";
      devices = [ "enceladus" "lapetus" ];
      versioning = commonVersioning;
    };
  };
}
