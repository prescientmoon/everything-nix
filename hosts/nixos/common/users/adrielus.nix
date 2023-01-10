{ pkgs, config, ... }:
let
  # Record containing all the hosts
  hosts = outputs.nixosConfigurations;

  # Function from hostname to relative path to public ssh key
  idKey = host: ../../${host}/id_ed25519.pub;
in
{
  # Password file stored through agenix
  age.secrets.adrielusPassword.file = ./adrielus_password.age;

  users = {
    # Configure users through nix only
    mutableUsers = false;

    # Create an user named adrielus
    users.adrielus = {
      # File containing my password, managed by agenix
      passwordFile = config.age.secrets.adrielusPassword.path;

      # Add user to the following groups
      extraGroups = [
        "wheel" # access to sudo
        "network" # for wireless stuff
        "networkmanager" # I assume this let's me access network stuff?
        "lp" # Allows me to use printers
        "docker" # Allows me to use docker (?)
        "audio" # Allows me to use audio devices
        "video" # Allows me to use a webcam

        # TODO: find out why I added these here a long time ago
        "sound"
        "input"
        "tty"
      ];

      # Adds me to some default groups, and creates the home dir 
      isNormalUser = true;
    };

    openssh.authorizedKeys.keyFiles =
      builtins.attrValues # attrsetof path -> path[]
        (builtins.mapAttrs # ... -> attrsetof host -> attrsetof path
          (name: _: idKey name) # string -> host -> path
          hosts);
  };
}
