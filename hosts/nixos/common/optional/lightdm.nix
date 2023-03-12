{
  services.xserver = {
    enable = true;
    displayManager.lightdm = {
      enable = true;

      greeters.enso = {
        enable = true;
        blur = true;
      };
    };
  };

  stylix.targets.lightdm.enable = true;
}

