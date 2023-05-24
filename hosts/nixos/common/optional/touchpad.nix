# My touchpad configuration
{ ... }: {
  services.xserver.libinput = {
    enable = true;

    touchpad = {
      # How fast we should scroll I think
      accelSpeed = "3.5";

      # Inverts axis
      naturalScrolling = true;

      # Dsiable the touchpad while typing 
      disableWhileTyping = true;

      # This is the most evil setting ever. 
      # I cannot imagine living with this on
      tappingDragLock = false;
    };
  };
}
