{ ... }: {
  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";

    # Enable the KDE Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    libinput = {
      # Enable touchpad support.
      enable = true;

      naturalScrolling = true;
      accelSpeed = "3.5";

      # who thought letting this be true by default was a good idea
      tappingDragLock = false;
    };
  };

  hardware.opengl.enable = true;
}
