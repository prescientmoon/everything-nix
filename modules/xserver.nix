{ ... }: {
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    xkbOptions = "eurosign:e";

    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

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
