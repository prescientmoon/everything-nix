{
  imports = [ ../../common/optional/syncthing.nix ];

  services.syncthing = {
    devices.tethys.id = "NGHX5G4-IY3ZXL2-NQMMRQV-2GDQLC6-LIDWSNG-DAJUAQH-KBAP64V-55K2LQ6";

    folders = {
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
  };
}
