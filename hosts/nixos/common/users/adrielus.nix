{ pkgs, outputs, config, lib, ... }:
{
  # Password file stored through agenix
  age.secrets.adrielusPassword.file = ./adrielus_password.age;

  users = {
    # Configure users through nix only
    mutableUsers = false;

    # Create an user named adrielus
    users.adrielus = {
      # Adds me to some default groups, and creates the home dir 
      isNormalUser = true;

      # Not sure if this works, but it's supposed to be the password
      # assigned when the user is first created.
      initialPassword = "pleasechangeme";

      # File containing my password, managed by agenix
      passwordFile = config.age.secrets.adrielusPassword.path;

      # Set default shell
      shell = pkgs.fish;

      # Add user to the following groups
      extraGroups = [
        "wheel" # Access to sudo
        "lp" # Printers
        "audio" # Audio devices
        "video" # Webcam and the like
        "network" # wpa_supplicant
        "syncthing" # syncthing!
      ];

      openssh.authorizedKeys.keyFiles =
        (import ./common.nix).authorizedKeys { inherit outputs lib; };
    };
  };
}
