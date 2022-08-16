{ pkgs, ... }:
let
  base16-schemes =
    pkgs.fetchFromGitHub {
      owner = "base16-project";
      repo = "base16-schemes";
      rev = "99529527e7cb3d777fb6e041c2aabbe6cdec4c4c";
      sha256 = "08avs0fykyjl1k3476vhm9rm0hvrpl2hfmc78r3h6yfnjnnl6q66";
    };

in
{
  imports = [
    # ./gtk.nix # Sets up gtk theming
    ./xresources.nix # Sets up xresources
    ./fonts.nix # Installs fonts and stuff (TODO: consider moving this into the individual themes which require these fonts?)
    ./wallpaper.nix # Sets the wallpaper required by the current theme
  ];

  stylix = {
    image = ./wallpapers/synthwave.jpg;
    polarity = "dark";

    autoEnable = false;
    targets.grub.enable = true;

    base16Scheme = "${base16-schemes}/catppuccin.yaml";
  };
}
