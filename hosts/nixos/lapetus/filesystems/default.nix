{ lib, ... }:
{
  imports = [
    ./zfs.nix
    (import ./partitions.nix { })
  ];

  # Mark a bunch of paths as needed for boot
  fileSystems = lib.attrsets.genAttrs
    [ "/" "/nix" "/persist/data" "/persist/state" "/persist/local/cache" "/boot" ]
    (p: {
      neededForBoot = true;
      # We need the extra check to allow nix to topologically sort everything
      depends = lib.mkIf (p != "/") [ "/hermes" ];
    });
}
