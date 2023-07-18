# Mark a bunch of paths as needed for boot
{ lib, ... }:
{
  fileSystems = lib.attrsets.genAttrs
    [ "/" "/nix" "/persist/data" "/persist/state" "/persist/local/cache" "/boot" ]
    (_: { neededForBoot = true; });
}
