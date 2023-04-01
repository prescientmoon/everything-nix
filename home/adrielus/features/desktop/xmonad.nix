{ pkgs, ... }: {
  imports = [
    ./common/rofi
    ./common/polybar
    ./common/eww
    ./common/wezterm
    ./common/alacritty.nix
    ./common/feh.nix
  ];

  # Other packages I want to install:
  home.packages = with pkgs; [
    vimclip # Vim anywhere!
    xclip # Clipboard stuff
    spectacle # Take screenshots
  ];

  stylix.targets = {
    xresources.enable = true;
    gtk.enable = true;
  };
}
