{
  services.syncthing = {
    enable = true;

    openDefaultPorts = true;

    configDir = "/home/adrielus/.config/syncthing";
    dataDir = "/persist/data/syncthing";

    user = "adrielus";
    group = "syncthing";
    # guiAddress = "0.0.0.0:8384"; # TODO: put this behind nginx

    overrideDevices = true;
    overrideFolders = true;

    devices = {
      "enceladus" = { id = "QWOAERM-V2FNXPI-TB7NFUS-LKW7JTB-IZY4OEZ-FYDPJNP-6IKPW4Y-YREXDQM"; };
    };

    folders = {
      "stellar-sanctum" = {
        path = "/home/adrielus/Projects/stellar-sanctum/";
        devices = [ "enceladus" ];

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
