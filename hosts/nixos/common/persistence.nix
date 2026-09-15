# This file defines the "non-hardware dependent" part of opt-in persistence It
# imports impermanence, defines the basic persisted directories, and ensures
# each users' home persistent directory exists and has the right permissions.
#
# It works when / is on tmpfs/btrfs/ZFS, or even not ephemeral at all.
{ config, lib, ... }:
{
  imports = [ ../../../infinite-impermanence/nixos.nix ];

  satellite.persistence = {
    enable = lib.mkDefault true;

    at.data = {
      bounds.source = "/persist/data";
    };

    at.state = {
      bounds.source = "/persist/state";
      directories = [
        "/var/lib/systemd"
        "/var/lib/nixos"
      ];
    };

    at.cache = {
      bounds.source = "/persist/local/cache";
      directories = [
        "/var/log"
      ];
    };

    # We ensure every home directory exists not only under /, but also under
    # the various persistent volumes.
    scaffolding =
      let
        users = lib.attrValues config.users.users;
        normalUsers = lib.filter (v: v != null && v.isNormalUser) users;
        mkHomePersistFor =
          location:
          lib.forEach normalUsers (user: {
            path = "${location}${user.home}";
            mode = user.homeMode;
            user = user.name;
            group = user.group;
          });
      in
      lib.concatMap mkHomePersistFor [
        "" # Should this be here?
        "/persist/data"
        "/persist/state"
        "/persist/local/cache"
      ];
  };

  # When one first uses "sudo", they get a message about using it responsible
  # or whatnot. Because of my impermanence setup, sudo forgets its already
  # given the lecture in the past, making it give it again after each reboot.
  # This simply disables that behaviour.
  security.sudo.extraConfig = "Defaults lecture = never";
}
