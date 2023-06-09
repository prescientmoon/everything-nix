# Taken from [misterio's config](https://github.com/Misterio77/nix-config/blob/main/modules/home-manager/monitors.nix)
# This is meant to provide a wm-independent way of specifying the monitor configuration of each machine.
{ lib, ... }:
{
  options.monitors = lib.mkOption {
    type = lib.types.listOf (lib.types.submodule {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          example = "DP-1";
        };

        width = lib.mkOption {
          type = lib.types.int;
          example = 1920;
        };

        height = lib.mkOption {
          type = lib.types.int;
          example = 1080;
        };

        refreshRate = lib.mkOption {
          type = lib.types.int;
          default = 60;
        };

        x = lib.mkOption {
          type = lib.types.int;
          default = 0;
        };

        y = lib.mkOption {
          type = lib.types.int;
          default = 0;
        };

        enabled = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };

        workspace = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      };
    });
  };
}
