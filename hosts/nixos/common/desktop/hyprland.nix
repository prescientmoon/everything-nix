{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.satellite.hyprland;
in
{
  options.satellite.hyprland = {
    enable = lib.mkEnableOption "satellite's hyprland integration";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        message = "Hyprland can only be used on graphical machines.";
        assertion = config.satellite.machine.graphical;
      }
    ];

    # The main configuration is specified by home-manager
    programs.hyprland.enable = true;
    # programs.hyprland.withUWSM = true;
    programs.hyprland.package = pkgs.hyprland;
    services.udev.packages = [ pkgs.swayosd ];

    # Add this to PATH so tools can find `hyprctl`
    environment.systemPackages = [ config.programs.hyprland.package ];
  };
}
