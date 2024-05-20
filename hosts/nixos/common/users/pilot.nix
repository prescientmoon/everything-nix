{ pkgs, outputs, config, lib, ... }:
{
  satellite.pilot.name = "adrielus";

  sops.secrets.pilot_password = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  users = {
    # Configure users through nix only
    mutableUsers = false;

    users.pilot = {
      inherit (config.satellite.pilot) name;

      # Adds me to some default groups, and creates the home dir 
      isNormalUser = true;

      # Picked up by our persistence module
      homeMode = "700";

      # Add user to the following groups
      extraGroups = [
        "wheel" # Access to sudo
        "lp" # Printers
        "audio" # Audio devices
        "video" # Webcam and the like
        "network" # wpa_supplicant
        "syncthing" # syncthing!
      ];

      hashedPasswordFile = config.sops.secrets.pilot_password.path;
      shell = pkgs.fish;

      openssh.authorizedKeys.keyFiles =
        (import ./common.nix).authorizedKeys { inherit outputs lib; };
    };
  };
}
