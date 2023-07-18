{
  fileSystems =
    let zfs = { neededForBoot = true; options = [ "zfsutil" ]; };
    in
    {
      "/" = zfs;
      "/nix" = zfs;
      "/persist/data" = zfs;
      "/persist/state" = zfs;
      "/persist/local/cache" = zfs;
      "/boot".neededForBoot = true;
    };
}
