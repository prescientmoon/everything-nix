{ pkgs, lib, ... }:
let
  theme = pkgs.myThemes.current;
  rofi = pkgs.rofi.override
    {
      plugins = with pkgs;[
        rofi-power-menu
        rofi-calc
        rofi-emoji
      ];
    };
in
{
  home-manager.users.adrielus = {
    home.packages = [ rofi ];
    home.file.".local/share/rofi/themes".source = theme.rofi.themes or "/home/adrielus/.temp-empty-rofi-themes-directory";

    xdg.configFile."rofi/config.rasi".text = ''
      @import "${./pre.rasi}"
      ${theme.rofi.config or ""}
    '';
  };
}
