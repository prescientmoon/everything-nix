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

    displayManager = {
      # make xmonad session the default
      defaultSession = "none+xmonad";

      # enable startx
      # startx.enable = true;
      sddm.enable = true;

      # autoLogin = {
      #   enable = true;
      #   user = "adrielus";
      # };
    };
  };
}

