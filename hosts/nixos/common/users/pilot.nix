{
  pkgs,
  outputs,
  config,
  lib,
  ...
}:
{
  # This is it's own attribute in order to prevent infinite recursion
  # in certain places.
  satellite.pilot.name = lib.mkDefault "adrielus";

  # {{{ Password handling
  sops.secrets.pilot_password = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };
  # }}}

  users = {
    # Configure users through nix only
    mutableUsers = false;

    # {{{ Create pilot user
    users.pilot = {
      inherit (config.satellite.pilot) name;

      # This gets referenced in other parts of the config
      uid = 1000;

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

      openssh.authorizedKeys.keyFiles = (import ./common.nix).authorizedKeys { inherit outputs lib; };
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
      "Z ${root}             0755 ${user.name} ${user.group}"
      "d ${root}/.ssh        0755 ${user.name} ${user.group}"
      "z ${root}/.ssh/id_rsa 0700 ${user.name} ${user.group}"
      "z ${root}/.ssh/id_ed25519 0700 ${user.name} ${user.group}"
    ];
  # }}}
}
