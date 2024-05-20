# This file defines the "non-hardware dependent" part of opt-in persistence
# It imports impermanence, defines the basic persisted dirs, and ensures each
# users' home persist dir exists and has the right permissions
#
# It works even if / is tmpfs, btrfs snapshot, or even not ephemeral at all.
{ lib, inputs, config, ... }: {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence."/persist/state".directories = [
    "/var/lib/systemd"
    "/var/lib/nixos"
    "/var/log"
  ];

  # Allow non root users to specify the "allowOther" option.
  # See [the imperanence readme](https://github.com/nix-community/impermanence#home-manager)
  programs.fuse.userAllowOther = true;

  # {{{ Create home directories
  systemd.tmpfiles.rules =
    let
      users = lib.filter (v: v != null && v.isNormalUser)
        (lib.mapAttrsToList (_: u: u) config.users.users);

      mkHomePersistFor = location: lib.forEach users
        (user: "Q ${location}${user.home} ${user.homeMode} ${user.name} ${user.group} -");
    in
    lib.flatten [
      (mkHomePersistFor "/persist/data")
      (mkHomePersistFor "/persist/state")
      (mkHomePersistFor "/persist/local/cache")
    ];
  # }}}
}

