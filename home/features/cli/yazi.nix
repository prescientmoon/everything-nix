{
  pkgs,
  ...
}:
{
  stylix.targets.yazi.enable = true;
  home.packages = [
    pkgs.yazi # Terminal file explorer
    pkgs.exiftool # Read file metadata
  ];
}
