{ pkgs, ... }: {
  imports = [
    ../desktop/eww
    ./rofi
    ./polybar
    ./feh.nix
  ];

  # Other packages I want to install:
  home.packages = with pkgs; [
    xclip # Clipboard stuff
    spectacle # Take screenshots
    vimclip # Vim anywhere!
  ];
}
