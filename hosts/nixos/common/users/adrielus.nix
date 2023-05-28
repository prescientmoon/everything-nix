{ pkgs, outputs, config, lib, ... }:
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
      # Adds me to some default groups, and creates the home dir 
      isNormalUser = true;

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
        "network" # for wireless stuff (???)
      ];

      openssh.authorizedKeys.keyFiles =
        lib.pipe hosts [
          # attrsetof host -> attrsetof path
          (builtins.mapAttrs
            (name: _: idKey name)) # string -> host -> path

          # attrsetof path -> path[]
          builtins.attrValues

          # path[] -> path[]
          (builtins.filter builtins.pathExists)
        ];
    };
  };
}
