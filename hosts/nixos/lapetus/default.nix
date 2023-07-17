{ config, ... }:
let
  device = "/dev/sda";
in
{
  imports = [
    ../common/global
    ../common/users/adrielus.nix
    ../common/optional/slambda.nix

    ./hardware-configuration.nix
  ];

  # Set the name of this machine!
  networking.hostName = "lapetus";

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

  disko.devices = import ./partitions.nix {
    devices = [ device ];
  };

  # Boot
  boot.loader.grub = {
    inherit device;
    enable = true;
    version = 2;
  };
}
