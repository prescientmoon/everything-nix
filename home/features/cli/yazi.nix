{ pkgs, ... }:
{
  stylix.targets.yazi.enable = true;

  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
  };

  home.packages = [
    pkgs.exiftool # Read file metadata
  ];
}
