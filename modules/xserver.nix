{ ... }: {
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    xkbOptions = "eurosign:e";

    # Make the xmonad session the default
    displayManager.defaultSession = "none+xmonad";

    # Enable xmonad
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };

    # Enable xfce I think?
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };

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
