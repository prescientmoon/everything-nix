{
  imports = [ ../../common/optional/syncthing.nix ];

  services.syncthing.settings.folders = {
    "mythical-vault" = {
      path = "/home/adrielus/.password-store";
      devices = [ "enceladus" "lapetus" ];
    };
    "stellar-sanctum" = {
      path = "/home/adrielus/Projects/stellar-sanctum/";
      devices = [ "enceladus" "lapetus" ];

      # TODO: remove this once I switch to zfs
      versioning = {
        type = "staggered";
        params = {
          cleanInterval = "3600"; # 1 hour in seconds
          maxAge = "604800"; # 14 days in seconds.
        };
      };
    };
  };
}
