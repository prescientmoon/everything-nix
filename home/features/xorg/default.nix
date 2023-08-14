{ pkgs, ... }: {
  imports = [
    ../desktop/batsignal.nix
    ./rofi
    ./polybar
    ./feh.nix
  ];

  # Other packages I want to install:
  home.packages = with pkgs; [
    xclip # Clipboard stuff
    spectacle # Take screenshots
  ];
}
