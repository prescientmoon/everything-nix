{ pkgs, ... }:
{
  # Configure ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "zroot" ];
  boot.kernelParams = [ "nohibernate" ];

  # {{{ Rollback
  boot.initrd.systemd.services.rollback = {
    path = [ pkgs.zfs ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    unitConfig.DefaultDependencies = "no";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import.target" ];
    before = [ "sysroot.mount" ];
    script = "zfs rollback -r zroot@blank";
  };
  # }}}
}
