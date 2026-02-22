{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.satellite.pilot = {
    # This is its own attribute in order to prevent infinite recursion issues in
    # certain places.
    #
    # Overall, this is here such that different devices can use different
    # usernames without causing issues over time.
    name = lib.mkOption { type = lib.types.str; };
  };

  config = {
    # Password handling
    sops.secrets.pilot_password = {
      sopsFile = ../secrets.yaml;
      neededForUsers = true;
    };

    users = {
      # Configure users through nix only
      mutableUsers = false;

      # Sync up root and `pilot` shell
      users.root.shell = config.users.users.pilot.shell;

      # {{{ Create pilot user
      users.pilot = {
        inherit (config.satellite.pilot) name;

        # This gets referenced in other parts of the configuration
        uid = 1000;

        # Adds me to some default groups, and creates the home directory
        isNormalUser = true;

        # Picked up by our persistence module
        homeMode = "711";

        # Add user to the following groups
        extraGroups = [
          "wheel" # Access to sudo
          "lp" # Printers
          "audio" # Audio devices
          "video" # Webcam and the like
          "syncthing" # syncthing!
        ];

        hashedPasswordFile = config.sops.secrets.pilot_password.path;
        shell = pkgs.fish;
      };
      # }}}
    };

    # {{{ Set user-specific ssh permissions
    # This is mainly useful because home-manager can often fail if the perms on
    # `~/.ssh` are incorrect.
    systemd.tmpfiles.rules =
      let
        user = config.users.users.pilot;
        root = "/persist/state/${user.home}/ssh";
      in
      [
        "d ${root}                 0755 ${user.name} ${user.group}"
        "d ${root}/.ssh            0755 ${user.name} ${user.group}"
        "z ${root}/.ssh/id_*.pub   0755 ${user.name} ${user.group}"
        "z ${root}/.ssh/id_rsa     0700 ${user.name} ${user.group}"
        "z ${root}/.ssh/id_ed25519 0700 ${user.name} ${user.group}"
      ];
    # }}}
  };
}
