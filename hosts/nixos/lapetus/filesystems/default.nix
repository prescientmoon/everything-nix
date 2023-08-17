{ lib, ... }:
{
  imports = [
    ./zfs.nix
    (import ./partitions.nix {
      disks = [ "/dev/sda" ];
    })
  ];

  # Mark a bunch of paths as needed for boot
  fileSystems = lib.attrsets.genAttrs
    [ "/" "/nix" "/persist/data" "/persist/state" "/persist/local/cache" "/boot" ]
    (_: { neededForBoot = true; });
}
