{ pkgs, lib, ... }:
let
  theme = pkgs.myThemes.current;
in
{
  imports = [
    {
      # Load theme
      home-manager.users.adrielus.programs.alacritty.settings = theme.alacritty.settings;
    }
  ];

  home-manager.users.adrielus.programs.alacritty = {
    enable = true;

    settings = {
      window.decorations = "none";
      fonts.normal.family = "Nerd Font Source Code Pro";
    };
  };
}
