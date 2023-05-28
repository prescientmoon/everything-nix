{ lib, config, ... }:
let greeter = "enso";
in
{
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm = {
    enable = true;

    greeters.slick = lib.mkIf (greeter == "slick") {
      enable = true;
      draw-user-backgrounds = true;
      font = config.stylix.fonts.sansSerif;
    };

    greeters.enso = lib.mkIf (greeter == "enso") {
      enable = true;
      blur = true;
    };
  };

  # Set default display manager
  services.xserver.displayManager.defaultSession = lib.mkDefault "hyprland";

  stylix.targets.lightdm.enable = true;
}

