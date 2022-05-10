{ pkgs, ... }:
let
  theme = pkgs.myThemes.current;
in
{
  home-manager.users.adrielus.programs.rofi = {
    enable = true;
    font = "Source Code Pro 16";
    location = "center";
    # padding = 10;
    # lines = 7;
    # fullscreen = false;
    cycle = true;
    theme = theme.rofi.theme;
    extraConfig = theme.rofi.config;
  };
}
