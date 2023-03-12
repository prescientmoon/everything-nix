{ pkgs, config, ... }:
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

    # Make xmonad session the default
    displayManager.defaultSession = "none+xmonad";
  };

  # Enable ad-hoc stylix targets:
  stylix.targets = {
    gtk.enable = true;
  };
}

