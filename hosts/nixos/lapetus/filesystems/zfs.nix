{ config, pkgs, ... }:
let secretMountpoint = "/hermes";
in
{
  # Configure ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "zroot" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "nohibernate" ];

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
