{ config, ... }:
let
  device = "/dev/sda";
  disko = import ./partitions.nix {
    devices = [ device ];
  };
in
{
  imports = [
    ../common/global
    ../common/users/adrielus.nix
    ../common/optional/slambda.nix

    ./hardware-configuration.nix
    disko
  ];

  # Set the name of this machine!
  networking.hostName = "lapetus";

  # ID required by zfs.
  # Generated with `head -c 8 /etc/machine-id`.
  networking.hostId = "08357db3";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";

  # Configure ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "zroot" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;

  # We use non-legacy mountpoints
  # See [this wiki link](https://nixos.wiki/wiki/ZFS)
  # systemd.services.zfs-mount.enable = false;

  # Roll back to blank snapshot on boot
  # boot.initrd.postDeviceCommands = lib.mkAfter ''
  #   zfs rollback -r zroot@blank
  # '';

  # {{{ Filesystems
  filesystems =
    let zfs = { neededForBoot = true; options = [ "zfsutil" ]; };
    in
    {
      "/" = zfs;
      "/nix" = zfs;
      "/persist/data" = zfs;
      "/persist/state" = zfs;
      "/persist/local/cache" = zfs;
      "/boot" = {
        neededForBoot = true;
        options = [ "zfsutil" "X-mount.mkdir" ];
      };
    };
  # }}}

  # Boot
  boot.loader.grub = {
    inherit device;
    enable = true;
    version = 2;
  };
}
