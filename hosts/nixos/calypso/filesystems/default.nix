{ lib, pkgs, ... }:
{
  imports = [ (import ./partitions.nix { }) ];

  boot.supportedFilesystems = [ "btrfs" ];
  services.btrfs.autoScrub.enable = true;

  # {{{ Mark a bunch of paths as needed for boot
  fileSystems =
    lib.attrsets.genAttrs
      [
        "/"
        "/nix"
        "/persist/data"
        "/persist/state"
        "/persist/local/cache"
        "/boot"
      ]
      (p: {
        neededForBoot = true;
      });
  # }}}
  # {{{ Rollback
  boot.initrd.systemd.services.rollback = {
    path = [ pkgs.btrfs-progs ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    unitConfig.DefaultDependencies = "no";
    wantedBy = [ "initrd.target" ];
    after = [ "systemd-cryptsetup@enc.service" ];
    before = [ "sysroot.mount" ];
    script = ''
      btrfs subvolume delete /
      btrfs subvolume create /
    '';
  };
  # }}}
}
