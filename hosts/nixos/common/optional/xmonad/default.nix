{ pkgs, config, ... }:
{
  services.xserver = {
    enable = true;

    # Enable xmonad
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;

      config = builtins.readFile (config.scheme {
        template = builtins.readFile ./Main.hs;
      });
    };

    # Proper wallpaper zooming
    desktopManager.wallpaper.mode = "fill";

    # Make xmonad session the default
    displayManager.defaultSession = "none+xmonad";
  };
}

