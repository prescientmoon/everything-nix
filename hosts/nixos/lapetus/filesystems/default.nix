{ lib, ... }:
{
  imports = [
    ./zfs.nix
    (import ./partitions.nix { })
  ];

  # Mark a bunch of paths as needed for boot
  fileSystems = lib.attrsets.genAttrs
    [ "/" "/nix" "/persist/data" "/persist/state" "/persist/local/cache" "/boot" ]
    (_: {
      neededForBoot = true;
      depends = [ "/hermes" ];
    });
}
