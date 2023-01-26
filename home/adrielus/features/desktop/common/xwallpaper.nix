{ config, ... }:
let
  wallpapers = {
    "Catppuccin Latte" = ./wallpapers/wall.png;
    "Catppuccin Frappe" = ./wallpapers/nix-catppuccin.png;
  };
in
{
  home.file.".background-image".source = wallpapers.${config.scheme.scheme};
}
