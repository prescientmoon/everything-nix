{ pkgs, outputs, config, lib, ... }:
{
  sops.secrets.adrielus_password = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  users = {
    # Configure users through nix only
    mutableUsers = false;

    # Create an user named adrielus
    users.adrielus = {
      # Adds me to some default groups, and creates the home dir 
      isNormalUser = true;

      # Picked up by our persistence module
      homeMode = "755";

      # Add user to the following groups
      extraGroups = [
        "wheel" # Access to sudo
        "lp" # Printers
        "audio" # Audio devices
        "video" # Webcam and the like
        "network" # wpa_supplicant
        "syncthing" # syncthing!
      ];

      hashedPasswordFile = config.sops.secrets.adrielus_password.path;
      shell = pkgs.fish;

      openssh.authorizedKeys.keyFiles =
        (import ./common.nix).authorizedKeys { inherit outputs lib; };
    };
  };
}
