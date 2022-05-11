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
    home.file.".local/share/rofi/themes/${theme.name}.rasi".text = theme.rofi.theme or "";

    xdg.configFile."rofi/config.rasi".text = ''
      @import "${./pre.rasi}"
      ${theme.rofi.config or ""}
    '';
  };
}
