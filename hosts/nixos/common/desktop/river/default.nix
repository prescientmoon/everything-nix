{
  pkgs,
  upkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.satellite.river;
in
{
  imports = [ "${inputs.river-next}/river-module.nix" ];

  options.satellite.river = {
    enable = lib.mkEnableOption "satellite's river integration";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        message = "River can only be used on graphical machines.";
        assertion = config.satellite.machine.graphical;
      }
    ];

    programs.river-next = {
      enable = true;
      windowManagers = [ "rhine" ];
      channel.enable = true;
      extraPackages = [];
    };

    environment.systemPackages = [
      pkgs.grim # Screenshotting tool
      pkgs.awww # Wallpaper thingy :p
    ];

    services.udev.packages = [ pkgs.swayosd ];

    home-manager.users.pilot = {config, ...}: {
      xdg.configFile."river/config.rh".source = ./config.rh;
      satellite.persistence.at.cache.files = [
        "${config.xdg.cacheHome}/rhine.restore"
      ];
    };
  };
}
