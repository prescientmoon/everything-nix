{ pkgs, lib, ... }:
let
  theme = pkgs.myThemes.current;
in
{
  imports = [
    {
      home-manager.users.adrielus.programs.zathura.enable = true;
    }
  ];
  home-manager.users.adrielus = lib.mkIf theme.zathura.enable {
    xdg.configFile."zathura/${theme.zathura.name}".source = theme.zathura.theme;
    programs.zathura = {
      extraConfig = ''
        include ${theme.zathura.name}
      '';
    };
  };
}
