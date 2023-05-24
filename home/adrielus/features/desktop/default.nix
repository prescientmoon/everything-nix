{ pkgs, ... }: {
  imports = [
    ./common/rofi
    ./common/polybar
    ./common/eww
    ./common/feh.nix
  ];

  # Other packages I want to install:
  home.packages = with pkgs; [
    xclip # Clipboard stuff
    spectacle # Take screenshots
  ];

  stylix.targets.xresources.enable = true;
}
