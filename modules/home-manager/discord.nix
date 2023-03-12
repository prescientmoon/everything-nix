{ config, lib, pkgs, ... }:
let
  cfg = config.programs.discord;
in
{
  options.programs.discord = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    disableUpdateCheck = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    enableDevtools = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.discord
    ];


    xdg.configFile."discord/settings.json".text =
      builtins.toJSON
        {
          SKIP_HOST_UPDATE = cfg.disableUpdateCheck;
          DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = cfg.enableDevtools;
        };
  };
}

