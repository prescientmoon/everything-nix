{ lib, ... }:
{
  options.satellite.wireless = {
    enable = lib.mkEnableOption "satellite's WIFI integration" // {
      default = true;
    };

    backend = lib.mkOption {
      description = ''
        Determines which backend should be used for WIFI connectivity.
      '';

      type = lib.types.enum [
        "iwd"
        "wpa-supplicant"
      ];
    };
  };

  imports = [
    ./iwd
    ./wpa_supplicant.nix
  ];
}
