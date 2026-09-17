{
  pkgs,
  upkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.satellite.sway;
in
{
  options.satellite.sway = {
    enable = lib.mkEnableOption "satellite's sway integration";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        message = "Sway can only be used on graphical machines.";
        assertion = config.satellite.machine.graphical;
      }
    ];

    # programs.uwsm.enable = true;
    programs.sway = {
      enable = true;
      # package = upkgs.swayfx;
      package = upkgs.sway;
      wrapperFeatures.gtk = true;
      extraPackages = [ ];
    };

    environment.etc."sway/config".source = ./config;
    environment.systemPackages = [
      pkgs.grim # Screenshotting tool
      pkgs.xrandr
    ];
  };
}
