{
  pkgs,
  ...
}:
{
  stylix.targets.yazi.enable = true;
  programs.yazi.enable = true;
  home.packages = [
    pkgs.exiftool # Read file metadata
  ];
}
