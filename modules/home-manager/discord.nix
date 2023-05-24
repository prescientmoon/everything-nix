{ config, lib, pkgs, ... }:
let cfg = config.programs.discord;
in
{
  options.programs.discord = {
    enable = lib.mkEnableOption "Discord";
    enableOpenASAR = lib.mkEnableOption "openASAR";
    disableUpdateCheck = lib.mkEnableOption "update skipping";
    enableDevtools = lib.mkEnableOption "devtools";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.discord;
      description = "The discord package to install";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      [
        (if cfg.enableOpenASAR
        then cfg.package.override { withOpenASAR = true; }
        else cfg.package)
      ];

    xdg.configFile."discord/settings.json".text =
      builtins.toJSON
        {
          SKIP_HOST_UPDATE = cfg.disableUpdateCheck;
          DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = cfg.enableDevtools;
        };
  };
}

