{ lib, ... }:
{
  options.satellite.wireless = {
    enable = lib.mkEnableOption "satellite's WIFI integration" // {
      default = true;
    };

    active = lib.mkEnableOption "whether the WIFI service should be active" // {
      default = true;
    };

    backend = lib.mkOption {
      description = ''
        Determines which backend should be used for WIFI connectivity.
      '';

      type = lib.types.enum [
        "iwd"
        "wpa-supplicant"
        "network-manager"
      ];
    };
  };

  imports = [
    ./iwd.nix
    ./wpa_supplicant.nix
    ./network-manager.nix
  ];
}
