{ config, ... }: {
  # Configure ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "zroot" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [ "nohibernate" ];

  # Roll back to blank snapshot on boot
  # boot.initrd.postDeviceCommands = lib.mkAfter ''
  #   zfs rollback -r zroot@blank
  # '';
}
