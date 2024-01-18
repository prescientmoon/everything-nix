{ config, pkgs, ... }:
let secretMountpoint = "/hermes";
in
{
  # Configure ZFS
  boot.supportedFilesystems = [ "zfs" "ext4" ];
  boot.zfs.extraPools = [ "zroot" ];
  boot.zfs.requestEncryptionCredentials = [ "secure" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "nohibernate" ];

  fileSystems."/hermes" = {
    neededForBoot = true;
    device = "/dev/disk/by-uuid/9f795d9c-5ee0-4c53-a5bf-97767cd9a30b";
    fsType = "ext4";
    options = [ "x-systemd.automount" "nofail" ];
  };

  # # {{{ Mount usb for zfs secrets
  # boot.initrd.systemd.mounts = [{
  #   where = "/hermes";
  #   what = "/dev/sdb";
  #
  #   # The usb contains sensitive data that should only be readable to root
  #   # mountConfig.DirectoryMode = "0750";
  #
  #   wantedBy = [ "zfs-import.target" ];
  #   before = [ "zfs-import.target" ];
  # }];
  # # }}}

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
