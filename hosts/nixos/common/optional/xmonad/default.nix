{ pkgs, config, lib, ... }:
{
  services.xserver = {
    enable = true;

    # Enable xmonad
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;

      config = builtins.readFile (config.lib.stylix.colors {
        template = builtins.readFile ./Main.hs;
      });
    };

    # Proper wallpaper zooming
    desktopManager.wallpaper.mode = "fill";
  };
}

