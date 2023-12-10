{ lib, config, ... }:
let greeter = "enso";
in
{
  imports = [ ./xserver.nix ];

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
  # services.xserver.displayManager.defaultSession = lib.mkDefault "hyprland";
  services.xserver.displayManager.defaultSession = lib.mkDefault "none+xmonad";

  # Enable base16 styling
  stylix.targets.lightdm.enable = true;
}

