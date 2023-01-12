{ pkgs, ... }: {
  imports = [
    ./common/rofi
    ./common/polybar
    ./common/fonts.nix
    ./common/xresources.nix
    ./common/xwallpaper.nix
    ./common/alacritty.nix
  ];

  # Other packages I want to install:
  home.packages = with pkgs; [
    vimclip # Vim anywhere!
    xclip # Clipboard stuff
    spectacle # Take screenshots
  ];
}
