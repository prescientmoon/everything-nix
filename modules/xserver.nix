{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Required for the sddm theme
    libsForQt5.qt5.qtquickcontrols
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtbase
  ];

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    xkbOptions = "eurosign:e";

    # Make the xmonad session the default
    # displayManager.defaultSession = "none+xmonad";
    displayManager = {
      defaultSession = "none+xmonad";
      sddm = {
        enable = true;
        theme = "${pkgs.sddm-theme-chili}";
      };

      autoLogin = {
        enable = true;
        user = "adrielus";
      };
    };

    # Enable xmonad
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };

    # Enable xfce I think?
    # desktopManager = {
    #   xterm.enable = false;
    #   xfce = {
    #     enable = true;
    #     noDesktop = true;
    #     enableXfwm = false;
    #   };
    # };


    libinput = {
      # Enable touchpad support.
      enable = true;

      touchpad = {
        naturalScrolling = true;
        accelSpeed = "3.5";

        tappingDragLock = false;
      };
    };
  };

  services.fractalart.enable = true;
  hardware.opengl.enable = true;
}
