# This file defines the "non-hardware dependent" part of opt-in persistence
# It imports impermanence, defines the basic persisted directories, and ensures
# each users' home persistent directory exists and has the right permissions.
#
# It works even if / is tmpfs, a btrfs snapshot, or even not ephemeral at all.
{
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  # List of directories that must always remain persistent
  environment.persistence."/persist/state".directories = [
    "/var/lib/systemd"
    "/var/lib/nixos"
  ];

  environment.persistence."/persist/local/cache".directories = [
    "/var/log"
  ];

  # Allow non-root users to use the `allowOther` option. See the impermanence
  # readme: https://github.com/nix-community/impermanence#home-manager
  programs.fuse.userAllowOther = true;

  # Disable the default lecture shown when first using "sudo" on a machine.
  security.sudo.extraConfig = "Defaults lecture = never";

  # Create home directories
  systemd.tmpfiles.rules =
    let
      # Collect every normal user defined by the machine.
      users = lib.filter (v: v != null && v.isNormalUser) (
        lib.mapAttrsToList (_: u: u) config.users.users
      );

      # Create a persistent home directory at the given prefix.
      mkHomePersistFor =
        location:
        lib.forEach users (user: "d ${location}${user.home} ${user.homeMode} ${user.name} ${user.group} -");
    in
    lib.flatten [
      (mkHomePersistFor "/persist/data")
      (mkHomePersistFor "/persist/state")
      (mkHomePersistFor "/persist/local/cache")
    ];
}
