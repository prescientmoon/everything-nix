{ config, ... }:
{
  imports = [
    ../xserver.nix
    ../touchpad.nix
  ];
  services.xserver = {
    enable = true;

    # Enable xmonad
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;

      # TODO: substitute the missing $TERM* variables
      config = builtins.readFile (config.lib.stylix.colors { template = builtins.readFile ./Main.hs; });
    };

    # Proper wallpaper zooming
    desktopManager.wallpaper.mode = "fill";
  };
}
