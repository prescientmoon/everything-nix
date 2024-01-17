{ config, pkgs, ... }:
let secretMountpoint = "/hermes";
in
{
  # Configure ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "zroot" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "nohibernate" ];

  # {{{ Mount usb for zfs secrets
  boot.initrd.systemd.mounts = [{
    where = "/hermes";
    what = "/dev/sdb";

    # The usb contains sensitive data that should only be readable to root
    # mountConfig.DirectoryMode = "0750";

    wantedBy = [ "zfs-import.target" ];
    before = [ "zfs-import.target" ];
  }];
  # }}}

  boot.initrd.systemd.services = {
    # # {{{ Rollback 
    # rollback = {
    #   path = [ pkgs.zfs ];
    #   serviceConfig = {
    #     Type = "oneshot";
    #     RemainAfterExit = true;
    #   };
    #   unitConfig.DefaultDependencies = "no";
    #   wantedBy = [ "initrd.target" ];
    #   after = [ "zfs-import.target" ];
    #   before = [ "sysroot.mount" ];
    #   script = "zfs rollback -r zroot@blank";
    # };
    # # }}}
  };
}
